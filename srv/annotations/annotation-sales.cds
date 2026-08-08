using {ProductsService as ps} from '../products-service';

annotate ps.Sales with {
    month         @title: 'Month';
    monthCode     @title: 'Month Code';
    year          @title: 'Year';
    quantitySales @title: 'Quantity Sales';
};

annotate ps.Sales @(
    Analytics.AggregatedProperty #sum: {
        Name : 'Sales',
        AggregationMethod : 'sum',
        AggregatableProperty : quantitySales,
        @Common.Label : 'Sales'
    },
    Aggregation.ApplySupported: {
        GroupableProperties: [
            year,
            month
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : quantitySales
            }
        ]
    },
    UI.Chart  : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        Dimensions : [
            year, month
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#sum'
        ]
    },
);