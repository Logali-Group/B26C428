using {ProductsService as c} from '../products-service';

annotate c.VH_Categories with {
    @title : 'Categories'
    ID @Common : { 
        Text : category,
        TextArrangement : #TextOnly
     };
};
