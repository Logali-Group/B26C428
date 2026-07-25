namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

type MyDecimal : Decimal(5, 3);

entity Products : cuid, managed {
    product       : String(8);
    productName   : String(80);
    description   : LargeString;
    category      : Association to Categories; //category and category_ID
    subCategory   : Association to SubCategories; //subCategory and subCategory_ID
    supplier      : Association to Suppliers;
    statu         : Association to Status; //statu and statu_code
    price         : Decimal(5, 2);
    rating        : Decimal(3, 2);
    currency      : String;
    detail        : Association to ProductDetails; //detail and detail_ID
    toReviews     : Association to many Reviews
                        on toReviews.product = $self;
    toInventories : Association to many Inventories
                        on toInventories.product = $self;
    toSales       : Association to many Sales
                        on toSales.product = $self;
};

entity ProductDetails : cuid {
    baseUnit   : String default 'EA';
    width      : MyDecimal;
    height     : MyDecimal;
    depth      : MyDecimal;
    weight     : MyDecimal;
    unitVolume : String default 'CM';
    unitWeight : String default 'KG';
};

entity Categories : cuid {
    category        : String(80);
    toSubCategories : Association to many SubCategories
                          on toSubCategories.category = $self;
};

entity SubCategories : cuid {
    subcategory : String(250);
    category    : Association to Categories; //category and category_ID
};

entity Status : CodeList {
    key code        : String(20) enum {
            InStock = 'In Stock';
            OutOfStock = 'Out of Stock';
            LowAvailability = 'Low Availability'
        };
        criticality : Int16;
};

entity Suppliers : cuid {
    supplier     : String(10);
    supplierName : String(40);
    webAddress   : String(250);
    contact      : Association to Contacts;
}

entity Contacts : cuid {
    fullName    : String(40);
    email       : String(40);
    phoneNumber : String(14);
};

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    user       : String(20);
    reviewText : LargeString;
    product    : Association to Products;
};

entity Inventories : cuid {
    stockNumber : String(9);
    department  : Association to Departments;
    min         : Integer;
    max         : Integer;
    target      : Integer;
    quantity    : Decimal(4, 3);
    baseUnit    : String default 'EA';
    product     : Association to Products;
};

entity Departments : cuid {
    department : String(40);
};

entity Sales : cuid {
    month         : String(20);
    monthCode     : String(2);
    year          : String(4);
    quantitySales : Integer;
    product       : Association to Products;
};
