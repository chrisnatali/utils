function powerset(input) {
    var result = []; 
    var selections; // bitmap of current subset
    for(selections = 0; selections < Math.pow(2, input.length); selections++) {
        var subset = [];
        var index; // index into bitmap we're looking for
        for(index = 0; index < input.length; index++) {
            if(selections & (1 << index)) {
                subset.push(input[index]);
            }
        }
        result.push(subset);
    }
    return result;
}
   
    
