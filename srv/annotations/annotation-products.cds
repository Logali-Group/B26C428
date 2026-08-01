using {ProductsService as p} from '../products-service';

annotate p.Products with {
    image @title: 'Image' @UI.IsImage;
    product @title : 'Product';
    productName @title : 'Product Name';
    description @title : 'Description';
    category @title : 'Category';
    subCategory @title : 'Sub Category';
    supplier @title : 'Supplier';
    statu @title : 'Status';
    rating @title : 'Rating';
    price @title : 'Price' @Measures.ISOCurrency : currency;
    currency @title : 'Currency' @Common.IsCurrency: true;
};

annotate p.Products with {
    product @Common: {
        Text : productName
    };
    statu @Common : { 
        Text : statu.name,
        TextArrangement : #TextOnly
     };
     supplier @Common: {
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : supplier_ID, //2dc3b5ec-8b9d-4d98-8129-02133fda2c22
                    ValueListProperty : 'ID', //2dc3b5ec-8b9d-4d98-8129-02133fda2c22
                }
            ]
        }
     };
     subCategory @Common: {
        Text : subCategory.subcategory,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_SubCategories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : category_ID, //d59ad002-8c3e-4dfb-8f67-82c0c3c270f1 (Esta almacenado en la entidad Products en el campo category_ID)
                    ValueListProperty : 'category_ID' //d59ad002-8c3e-4dfb-8f67-82c0c3c270f1 (Lo selecciona el usuario)
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : subCategory_ID,
                    ValueListProperty : 'ID',
                }
            ]
        }
     };
     category @Common: {
        Text : category.category,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID',
                }
            ]
        }
     };
};



annotate p.Products with @(
    // Capabilities.FilterRestrictions: {
    //     $Type : 'Capabilities.FilterRestrictionsType',
    //     RequiredProperties : [
    //         product
    //     ],
    // },
    UI.SelectionFields: [
        product,
        category_ID,
        subCategory_ID,
        supplier_ID,
        statu_code
    ],
    UI.HeaderInfo: {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : description
        }
    },
    UI.LineItem  : [
        {
            $Type : 'UI.DataField',
            Value : image
        },
        {
            $Type : 'UI.DataField',
            Value : product
        },
        // {
        //     $Type : 'UI.DataField',
        //     Value : productName
        // },
        {
            $Type : 'UI.DataField',
            Value : category_ID
        },
        {
            $Type : 'UI.DataField',
            Value : subCategory_ID
        },
        {
            $Type : 'UI.DataField',
            Value : statu_code,
            Criticality : statu.criticality
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint',
            Label : 'Rating',
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            },
        },
        // {
        //     $Type : 'UI.DataField',
        //     Value : rating
        // },
        {
            $Type : 'UI.DataField',
            Value : price
        }
    ],
    UI.DataPoint: {
        $Type : 'UI.DataPointType',
        Visualization: #Rating,
        Value: rating
    }
);
