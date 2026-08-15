using {ProductsService as p} from '../products-service';
using from './annnotation-suppliers';
using {ProductDetails as pd} from './annotation-productdetail';
using {Reviews as r} from './annotation-reviews';
using {Inventories as i} from './annotation-inventories';
using {Sales as s} from './annotation-sales';

annotate p.Products with @odata.draft.enabled;

annotate p.Products with {
    image @title: 'Image' @UI.IsImage;
    product @title : 'Product';
    productName @title : 'Product Name';
    description @title : 'Description' @UI.MultiLineText;
    category @title : 'Category';
    subCategory @title : 'Sub Category';
    supplier @title : 'Supplier';
    statu @title : 'Status';
    rating @title : 'Rating';
    price @title : 'Price' @Measures.ISOCurrency : currency_code;
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
        Text : supplier.supplierName,
        TextArrangement : #TextOnly,
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
    Common.SideEffects: {
        $Type : 'Common.SideEffectsType',
        SourceProperties : [
            supplier_ID
        ],
        TargetEntities : [
            supplier
        ],
    },
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
    },
    UI.FieldGroup #Picture: {
        $Type : 'UI.FieldGroupType',
        Data:[
            {
                $Type : 'UI.DataField',
                Value : image,
                Label : ''
            }
        ]
    },
    UI.FieldGroup #SupplierAndCategory: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : category_ID
            },{
                $Type : 'UI.DataField',
                Value : subCategory_ID
            },
            {
                $Type : 'UI.DataField',
                Value : supplier_ID
            }
        ]
    },
    UI.FieldGroup #Description: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : ''
            }
        ]
    },
    UI.FieldGroup #Statu : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : statu_code,
                Label: '',
                Criticality : statu.criticality,
                @Common.FieldControl : {
                    $edmJson: {
                        $If:[
                            {
                                $Eq:[
                                    {
                                        $Path: 'IsActiveEntity'
                                    },
                                    false
                                ]
                            },
                            1, //ReadOnly
                            3 //Optional
                        ]
                    }
                }
            }
        ]
    },
    UI.DataPoint #Price : {
        $Type : 'UI.DataPointType',
        Visualization: #Number,
        Value: price
    },
    UI.FieldGroup #Price : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.DataPoint#Price',
                Label : ''
            }
        ]
    },
    UI.FieldGroup #Rating : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target : '@UI.DataPoint',
                Label : ''
            }
        ]
    },
    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Picture'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#SupplierAndCategory'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Description',
            Label : 'Description'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Statu',
            Label : 'Availability'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Price',
            Label : 'Price'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Rating',
            Label : 'Rating'
        }
    ],
    UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/@UI.FieldGroup',
                    Label : 'General Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/contact/@UI.FieldGroup',
                    Label : 'Contact'
                }
            ],
            Label: 'Supplier Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'detail/@UI.FieldGroup#TechnicalData',
            Label : 'Technical Data'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toReviews/@UI.LineItem',
            Label : 'Reviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toInventories/@UI.LineItem',
            Label : 'Inventories'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toSales/@UI.Chart',
            Label : 'Sales'
        }
    ]
);
