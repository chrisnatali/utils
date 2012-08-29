phase_root = { 'id': 1, 'children': [
                    { 'id': 2, 'children': [
                            { 'id': 4, 'children': []}
                            ]
                    },
                    { 'id': 3, 'children': [
                            { 'id': 5, 'children': []}
                            ]
                    },
                    { 'id': 6, 'children': []}
                    ]
             }

def to_print_rows(phase):
    """ 
    Create row based representation of tree like:
    \1
     \2
      \3
     \4
      \5
      \6
     \7
    """

    rows = []
    def populate_rows(ph, depth):
        row = {'id': ph['id'], 'cols': depth}      
        rows.append(row)
        for child in ph['children']:
            populate_rows(child, depth + 1)

    populate_rows(phase, 0)
    return rows


def print_tree(rows):
    for row in rows:
        str_row = ' ' * row['cols']
        print("%s\\%s" % (str_row, row['id']))
            
        





     
       

                        
