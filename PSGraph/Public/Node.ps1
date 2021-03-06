function Node 
{
    <#
        .Description
        Used to specify a nodes attributes or placement within the flow.

        .Example
        graph g {
            node one,two,three
        }

        .Example
        graph g {
            node top @{shape='house'}
            node middle
            node bottom @{shape='invhouse'}
            edge top,middle,bottom
        }

        .Example
        
        graph g {
            node (1..10) 
        }

        .Notes
        I had conflits trying to alias Get-Node to node, so I droped the verb from the name.
        If you have subgraphs, it works best to define the node inside the subgraph before giving it an edge
    #>
    [cmdletbinding()]
    param(
        # The name of the node
        [Parameter(
            Mandatory = $true, 
            ValueFromPipeline = $true,
            Position = 0
        )]
        [string[]]
        $Name = 'node',

        # Node attributes to apply to this node
        [Parameter( Position = 1 )]
        [hashtable]
        $Attributes    
    )

    begin
    {
        $GraphVizAttribute = ConvertTo-GraphVizAttribute -Attributes $Attributes
    }

    process
    {        
        foreach($node in $Name)
        {
            Write-Output ('{0}"{1}" {2}' -f (Get-Indent), $node, $GraphVizAttribute)
        }        
    }
}
