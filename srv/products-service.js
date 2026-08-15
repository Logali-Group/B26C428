const cds = require('@sap/cds');

module.exports = class ProductsService extends cds.ApplicationService {

    init () {

        const {Products, Inventories} = this.entities;

        //before
        //on
        //after
        //CREATE, READ, UPDATE, DELETE (Tabla Persistente) (NEW, PATCH, DELETE)

        this.before('NEW', Products.drafts, async (req) => {
            req.data.detail??={
                baseUnit: 'EA',
                width: null,
                height: null,
                depth: null,
                weight: null,
                unitWeight: 'KG',
                unitVolume: 'CM'
            };
        });

        this.before('NEW', Inventories.drafts, async (req) => {
            if (req.data.stockNumber) return;

            const [persistentMaxRow, draftMaxRow] = await Promise.all([
                SELECT.one.from(Inventories).columns('max(stockNumber) as max'),
                SELECT.one.from(Inventories.drafts).columns('max(stockNumber) as max')
            ]);

            const persistentMax = Number.parseInt(persistentMaxRow?.max ?? '0', 10) || 0;
            const draftMax = Number.parseInt(draftMaxRow?.max ?? '0', 10) || 0;
            const next = Math.max(persistentMax, draftMax) + 1;

            req.data.stockNumber = String(next).padStart(9, '0'); // 000000001
        });


        return super.init();
    }

};