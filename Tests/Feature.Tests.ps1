$projectRoot = Resolve-Path "$PSScriptRoot\.."
$moduleRoot = Split-Path (Resolve-Path "$projectRoot\*\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "$moduleName.psm1") -force


Describe "Basic function feature tests" {

    Context "Graph" {
        
        It "Graph support attributes" {

            {graph g {} -Attributes @{label="testcase";style='filled'}} | Should Not Throw
            
            $resutls = (graph g {} -Attributes @{label="testcase";style='filled'}) -join ''

            $resutls | Should Match 'label="testcase";'
            $resutls | Should Match 'style="filled";'
        }

        It "Items can be placed in a graph" {
            {
                graph test {
                    node helo
                    edge hello world
                    rank same level
                    subgraph 0 {

                    }
                }
            } | Should Not Throw
        }
    }

    Context "SubGraph" {
        It "Items can be placed in a subgraph" {
            {
                graph test {
                    subgraph 0 {
                        node helo
                        edge hello world
                        rank same level
                        subgraph 1 {

                        }
                    }
                }
            } | Should Not Throw
        }
    }

    Context "Node" {

        It "Can define multiple nodes at once" {

            {Node (1..5)} | Should Not Throw

            $result = Node (1..5)
            $result | Should not Be NullOrEmpty
            $result.count | Should be 5
            $result[0] | Should match '1'
            $result[4] | Should match '5'

            {Node one,two,three,four} | Should Not Throw
            {Node @(echo one two three four)} | Should Not Throw
        }
    }
    
    Context "Edge" {

        It "Can define multiple edges at once in a chain" {
            {Edge one,two,three} | Should Not Throw

            $result = Edge one,two,three
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 2
            $result[0] | Should match '"one"->"two"'
            $result[1] | Should match '"two"->"three"'
        }

        It "Can define multiple edges at once, with cross multiply" {
            {Edge one,two three,four} | Should Not Throw

            $result = Edge one,two three,four
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 4
            $result[0] | Should match '"one"->"three"'
            $result[1] | Should match '"one"->"four"'
            $result[2] | Should match '"two"->"three"'
            $result[3] | Should match '"two"->"four"'
        }
    }

    Context "Rank" {

        It "Can rank an array of items" {

            {rank (1..3)} | Should Not Throw

            $result = rank (1..3)
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 1
            $result | should match '{ rank=same;  "1" "2" "3"; }'
        }

         It "Can rank a list of items" {

            {rank one two three} | Should Not Throw

            $result = rank one two three
            $result | Should Not BeNullOrEmpty
            $result.count | Should be 1
            $result | should match '{ rank=same;  "one" "two" "three"; }'
        }
    }
}
