using {ProductsService as i} from '../products-service';


annotate i.Inventories with {
    department  @title: 'Department';
    min         @title: 'Minimum';
    max         @title: 'Maximum';
    target      @title: 'Target';
    quantity    @title: 'Quantity';
    baseUnit    @title: 'Base Unit';
    stockNumber @title: 'Stock Number';
};

annotate i.Inventories with {
    department @Common: {
        Text : department.department,
        TextArrangement : #TextOnly
    }
};

annotate i.Inventories with @(
    Capabilities.SearchRestrictions: {
        $Type : 'Capabilities.SearchRestrictionsType',
        Searchable: false
    },
     UI.HeaderInfo: {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Inventory',
        TypeNamePlural : 'Inventories',
        Title : {
            $Type : 'UI.DataField',
            Value : product.productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : product.description
        },
     },
    UI.LineItem :[
        {
            $Type : 'UI.DataField',
            Value : stockNumber
        },
        {
            $Type : 'UI.DataField',
            Value : department_ID
        },
        // {
        //     $Type : 'UI.DataField',
        //     Value : min
        // },
        // {
        //     $Type : 'UI.DataField',
        //     Value : max
        // },
        // {
        //     $Type : 'UI.DataField',
        //     Value : target
        // },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#Bullet',
            Label : 'Stock',
            @HTML5.CssDefaults : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            }
        },
        {
            $Type : 'UI.DataField',
            Value : quantity
        }
    ],
    UI.FieldGroup #DetailInventory : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : stockNumber
            },
            {
                $Type : 'UI.DataField',
                Value : department_ID
            },
            {
                $Type : 'UI.DataField',
                Value : min
            },
            {
                $Type : 'UI.DataField',
                Value : max
            },
            {
                $Type : 'UI.DataField',
                Value : target
            },
            {
                $Type : 'UI.DataField',
                Value : quantity
            }
        ]
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#DetailInventory',
            Label : 'General Information'
        }
    ],
    UI.DataPoint  : {
        $Type : 'UI.DataPointType',
        Value : target,
        MinimumValue: min, //0
        MaximumValue: max, //500
        CriticalityCalculation: {
            $Type : 'UI.CriticalityCalculationType',
            ImprovementDirection : #Maximize,
            ToleranceRangeLowValue : 200,
            DeviationRangeLowValue : 100,
        }
    },
    UI.Chart #Bullet : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bullet,
        Measures : [
            target
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DataPoint : '@UI.DataPoint',
                Measure : target
            }
        ]
    }
);
