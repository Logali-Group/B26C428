using {ProductsService as r} from '../products-service';

annotate r.Reviews with {
    product    @title: 'Product';
    rating     @title: 'Rating';
    reviewText @title: 'Review Text';
    date       @title: 'Date';
    user       @title: 'User';
};

annotate r.Reviews with @(
    UI.DataPoint #RatingDetail : {
        $Type : 'UI.DataPointType',
        Value : rating,
        Visualization : #Rating
    },
    UI.HeaderInfo: {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Review',
        TypeNamePlural : 'Reviews',
        Title : {
            $Type : 'UI.DataField',
            Value : product.productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : product.description
        },
    },  
    UI.LineItem : [
        // {
        //     $Type : 'UI.DataField',
        //     Value : rating,
        //     Label : 'Rating'
        // },
        {
            $Type: 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#RatingDetail',
            Label : 'Rating'
        },
        {
            $Type : 'UI.DataField',
            Value : user,
            Label : 'User'
        },
        {
            $Type : 'UI.DataField',
            Value : date,
            Label : 'Date'
        },
        {
            $Type : 'UI.DataField',
            Value : reviewText,
            Label : 'Review Text'
        }
    ],
    UI.FieldGroup #DetailReview: {
        $Type : 'UI.FieldGroupType',
        Data : [
        {
            $Type : 'UI.DataField',
            Value : rating,
            Label : 'Rating'
        },
        {
            $Type : 'UI.DataField',
            Value : user,
            Label : 'User'
        },
        {
            $Type : 'UI.DataField',
            Value : date,
            Label : 'Date'
        },
        {
            $Type : 'UI.DataField',
            Value : reviewText,
            Label : 'Review Text'
        }
        ],
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#DetailReview',
            Label : 'General Information'
        },
    ],
);
