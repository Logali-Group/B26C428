using {ProductsService as ps} from '../products-service';

annotate ps.ProductDetails with {
    baseUnit   @title: 'Base Unit';
    width      @title: 'Width' @Measures.Unit: unitVolume;
    height     @title: 'Height' @Measures.Unit: unitVolume;
    depth      @title: 'Depth' @Measures.Unit: unitVolume;
    weight     @title: 'Weight' @Measures.Unit: unitWeight;
    unitVolume @title: 'Unit Volume' @Common.IsUnit;
    unitWeight @title: 'Unit Weight' @Common.IsUnit;
};

annotate ps.ProductDetails with @(

    UI.FieldGroup #TechnicalData: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : width,
                Label : 'Width'
            },
            {
                $Type : 'UI.DataField',
                Value : height,
                Label : 'Height'
            },
            {
                $Type : 'UI.DataField',
                Value : depth,
                Label : 'Depth'
            },
            {
                $Type : 'UI.DataField',
                Value : weight,
                Label : 'Weight'
            }
        ]
    }

);
