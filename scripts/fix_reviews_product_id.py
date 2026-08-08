import csv
import shutil
from pathlib import Path

products_path = Path("/home/user/projects/B26C428/db/data/com.logaligroup-Products.csv")
reviews_path = Path("/home/user/projects/B26C428/db/data/com.logaligroup-Reviews.csv")
backup_path = reviews_path.with_suffix(reviews_path.suffix + ".bak")

if not products_path.exists():
    raise FileNotFoundError(f"No existe: {products_path}")
if not reviews_path.exists():
    raise FileNotFoundError(f"No existe: {reviews_path}")

with products_path.open("r", encoding="utf-8-sig", newline="") as f:
    products = list(csv.DictReader(f))

product_ids = set()
by_code = {}
by_name = {}

for p in products:
    pid = (p.get("ID") or "").strip()
    code = (p.get("product") or "").strip()
    name = (p.get("productName") or "").strip().lower()

    if pid:
        product_ids.add(pid)
    if code:
        by_code.setdefault(code, set()).add(pid)
    if name:
        by_name.setdefault(name, set()).add(pid)

with reviews_path.open("r", encoding="utf-8-sig", newline="") as f:
    reader = csv.DictReader(f)
    rows = list(reader)
    fieldnames = reader.fieldnames or []

if "product_ID" not in fieldnames:
    raise ValueError("La entidad Reviews no tiene la columna 'product_ID'.")

fixed = already_ok = unresolved = ambiguous = 0

for r in rows:
    current = (r.get("product_ID") or "").strip()

    if current in product_ids:
        already_ok += 1
        continue

    candidate_ids = set()
    rv_code = (r.get("product") or "").strip()
    rv_name = (r.get("productName") or "").strip().lower()

    if rv_code in by_code:
        candidate_ids |= by_code[rv_code]
    if rv_name in by_name:
        candidate_ids |= by_name[rv_name]
    if current in by_code:
        candidate_ids |= by_code[current]

    if len(candidate_ids) == 1:
        r["product_ID"] = next(iter(candidate_ids))
        fixed += 1
    elif len(candidate_ids) > 1:
        ambiguous += 1
    else:
        unresolved += 1

shutil.copy2(reviews_path, backup_path)

with reviews_path.open("w", encoding="utf-8", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)

print("=== Resultado validación/corrección Reviews.product_ID ===")
print(f"Total reviews      : {len(rows)}")
print(f"Ya correctos       : {already_ok}")
print(f"Corregidos         : {fixed}")
print(f"Ambiguos           : {ambiguous}")
print(f"No resueltos       : {unresolved}")
print(f"Backup generado en : {backup_path}")
