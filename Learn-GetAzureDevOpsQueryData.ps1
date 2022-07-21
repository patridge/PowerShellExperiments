# Requires Azure command line (`az`)
# Then log in via browser with `az login`

# If going to do some filtering/experimenting on a query result, set it to a local variable to avoid roundtrips to the server
$someVariable = (az boards query --id="9f62e57f-e043-4343-bd6f-0247994cd478" | ConvertFrom-Json)
# Filter locally based on some funky field name
($someVariable | ? { $_.Fields.{Custom.UID}.Contains("something") }).Length

# Get count from query by ID
# Ideally, this could be done by a JMESPath query, but none of the examples I found would work.
# WARNING: This does not get an accurate count when pagination is required.
#          https://github.com/Azure/azure-cli-extensions/issues/2825
(az boards query --id="9f62e57f-e043-4343-bd6f-0247994cd478" | ConvertFrom-Json).Length


@(
    [pscustomobject]@{
        name = "Feedback: Triaged";
        weekIndex = "0";
        id = "65fdf056-154c-4a5a-8340-34864ffc258c"
    },
    [pscustomobject]@{
        name = "Feedback: Resolved";
        weekIndex = "0";
        id = "e96128a9-fa99-428d-9f61-ba92b7d7e32d"
    },
    [pscustomobject]@{
        name = "Feedback: Backlog (team)";
        weekIndex = "0";
        id = "9f62e57f-e043-4343-bd6f-0247994cd478"
    },
    [pscustomobject]@{
        name = "Feedback: Backlog (first review)";
        weekIndex = "0";
        id = "75d3650f-f23a-4f4d-a726-0a5bfa121aeb"
    },
    [pscustomobject]@{
        name = "Feedback: P1 backlog";
        weekIndex = "0";
        id = "e8f403c1-7d9e-4c81-abc8-fe832664a1b7"
    },
    [pscustomobject]@{
        name = "Feedback: P2 backlog";
        weekIndex = "0";
        id = "4c099e44-5bdb-481f-aa7e-816e9f14c143"
    },
    [pscustomobject]@{
        name = "Learnbot: Created";
        weekIndex = "0";
        id = "9368b1b2-29fe-4ea0-ac41-c9368b5c6568"
    },
    [pscustomobject]@{
        name = "Modules: Live";
        weekIndex = "0";
        id = "831c83eb-22aa-449b-b25e-5c9e54949965"
    },
    [pscustomobject]@{
        name = "Modules: Healthy";
        weekIndex = "0";
        id = "2324bfa0-0c78-480c-8205-7a9e5d3ea213"
    },
    [pscustomobject]@{
        name = "Modules: Due for review";
        weekIndex = "0";
        id = "5a5129e5-30ed-400b-8737-297ae85bd8d6"
    },
    [pscustomobject]@{
        name = "Modules: Overdue for review";
        weekIndex = "0";
        id = "f816ec7b-700b-40a0-8833-04aaaa7b1819"
    },
    [pscustomobject]@{
        name = "Modules: Needs updates";
        weekIndex = "0";
        id = "be4fe0fe-f517-44bd-8e51-ef79016f6e24"
    },
    [pscustomobject]@{
        name = "Reviews: Completed total";
        weekIndex = "0";
        id = "5776ea78-4712-419f-98b9-516d9bd06ff7"
    },
    [pscustomobject]@{
        name = "Feedback: P1 SLA missed";
        weekIndex = "0";
        id = "a2a25c8a-1d3c-43cc-8f2e-0f5ac3614932"
    },
    [pscustomobject]@{
        name = "Feedback: P2 SLA missed";
        weekIndex = "0";
        id = "2814a282-d9f5-4d48-923b-5041d721c31c"
    },
    [pscustomobject]@{
        name = "Feedback: P3 SLA missed";
        weekIndex = "0";
        id = "4902b90f-e092-4113-ad68-35cd5972376f"
    },
    [pscustomobject]@{
        name = "Feedback: P4 SLA missed";
        weekIndex = "0";
        id = "236133c7-d5bb-43b7-b6dc-2f871a7d02f7"
    }
    # [pscustomobject]@{
    #     name = "XXXXX";
    #     weekIndex = "0";
    #     id = "12345"
    # },
    # [pscustomobject]@{
    #     name = "XXXXX";
    #     weekIndex = "0";
    #     id = "12345"
    # }
)
| Select-Object -First 1
| % {
    [pscustomobject]@{
        name = $_.name;
        weekIndex = $_.weekIndex;
        id = $_.id;
        count = (az boards query --id="$($_.id)" | ConvertFrom-Json).Length
    }
}


("[ {""title"": ""P1 received (last week)"", ""queryId"": ""7c0fd097-8d0d-4082-a56d-59e5b58b59cf"" } ]"
| ConvertFrom-Json)
| Select-Object -First 1
| % {
    [pscustomobject]@{
        name = $_.title;
        weekIndex = -1;
        id = $_.queryId;
        count = (az boards query --id="$($_.queryId)" | ConvertFrom-Json).Length
    }
}

# [
#   {
#     "title": "P1 received (last week)",
#     "count": "0",
#     "queryId": "7c0fd097-8d0d-4082-a56d-59e5b58b59cf/"
#   },
#   {
#     "title": "P2 received (last week)",
#     "count": "14",
#     "queryId": "c08d9c96-7266-45ba-87e5-f5226805cc38/"
#   },
#   {
#     "title": "P3 received (last week)",
#     "count": "40",
#     "queryId": "686bcd81-39b1-4944-affb-f8172f76aff7/"
#   },
#   {
#     "title": "P4+ received (last week)",
#     "count": "70",
#     "queryId": "d60c9e31-2821-4046-b312-1eba99a8fea1/"
#   },
#   {
#     "title": "Modules, live (all)",
#     "count": "488",
#     "queryId": "824d5841-3184-457f-986c-d7bf78e49843/"
#   },
#   {
#     "title": "P1 triaged (last week)",
#     "count": "18",
#     "queryId": "d694762a-514f-4504-8650-6536f871fa6c/"
#   },
#   {
#     "title": "P2 triaged (last week)",
#     "count": "-1",
#     "queryId": "8c224110-9654-406c-8622-fa617e401ce1/"
#   },
#   {
#     "title": "P3 triaged (last week)",
#     "count": "202",
#     "queryId": "028377a3-1fd0-4937-8c5d-5856960cf252/"
#   },
#   {
#     "title": "P4+ triaged (last week)",
#     "count": "109",
#     "queryId": "bc3370de-8745-434a-b0db-52274f5e6510/"
#   },
#   {
#     "title": "P1 resolved/rejected (last week)",
#     "count": "8",
#     "queryId": "3fe69977-36e4-4808-b7b8-9e6aa41d65d6/"
#   },
#   {
#     "title": "P2 resolved/rejected (last week)",
#     "count": "74",
#     "queryId": "e1d3619f-904c-4716-88f9-777b8695d5d7/"
#   },
#   {
#     "title": "P3 resolved/rejected (last week)",
#     "count": "130",
#     "queryId": "2a8ef636-fc97-4d72-9413-fda7d5e431d7/"
#   },
#   {
#     "title": "P4+ resolved/rejected (last week)",
#     "count": "108",
#     "queryId": "9cfbdfa5-3972-4bff-ae20-5475e0a00dbc/"
#   },
#   {
#     "title": "P1 SLA resolved (last week)",
#     "count": "0",
#     "queryId": "49f6a301-8176-4496-a2ca-36c7ed8abcf3/"
#   },
#   {
#     "title": "P2 SLA resolved (last week)",
#     "count": "1",
#     "queryId": "73280b0a-9f7d-4262-b432-abf862ca47df/"
#   },
#   {
#     "title": "P3 SLA resolved (last week)",
#     "count": "22",
#     "queryId": "6193b6da-33de-4eba-9d29-b764ad5a6f93/"
#   },
#   {
#     "title": "P4+ SLA resolved (last week)",
#     "count": "59",
#     "queryId": "484dd670-3609-4e46-8514-1eb9d7187c2c/"
#   },
#   {
#     "title": "P1 open (all)",
#     "count": "21",
#     "queryId": "d0b3a46e-fb27-4501-93da-0481c3226a65/"
#   },
#   {
#     "title": "P2 open (all)",
#     "count": "144",
#     "queryId": "3cecf97a-0831-4ced-a99a-329bac095230/"
#   },
#   {
#     "title": "P3 open (all)",
#     "count": "-1",
#     "queryId": "1d2e5774-988b-4154-95f3-1335c645b368/"
#   },
#   {
#     "title": "P4+ open (all)",
#     "count": "130",
#     "queryId": "7c982391-d28e-418a-bd17-f4677f33b5ff/"
#   },
#   {
#     "title": "Content problem, resolved/rejected (last week)",
#     "count": "157",
#     "queryId": "9a441e24-9edf-45c5-a667-4191e39af18c/"
#   },
#   {
#     "title": "Content needed clarity, resolved/rejected (last week)",
#     "count": "13",
#     "queryId": "e5bfd148-a7fb-4089-a253-467b4b0569e6/"
#   },
#   {
#     "title": "Product changed, resolved/rejected (last week)",
#     "count": "11",
#     "queryId": "000d0369-de9e-45b4-8dba-4a589bd1cd71/"
#   },
#   {
#     "title": "Cannot reproduce, resolved/rejected (last week)",
#     "count": "36",
#     "queryId": "67126a22-2ac0-4fdd-8f8f-62e1c47bb885/"
#   }
# ]

# Example: get query results by WIQL
az boards query --wiql="SELECT [System.Id], [System.WorkItemType], [System.Title], [System.AssignedTo], [System.State], [System.Tags], [System.CreatedDate] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Customer Feedback' AND [Custom.FeedbackSource] <> 'Star rating verbatim' AND [System.CreatedDate] < @startOfWeek AND [System.CreatedDate] >= @startOfWeek('-1') AND [System.AreaPath] UNDER 'Microsoft Learn\Customer Feedback' ORDER BY [System.Id] DESC" | ConvertFrom-Json | Measure-Object | % { $_.Count }

# Get the total issues-created count for each week for most of the last year
1..5 | % { (Get-Date).AddDays((-1 * (Get-Date).DayOfWeek.Value__) + 1).Date.AddDays($_ * -7) } | % { @{ StartDate = $_.AddDays(-7); EndDate = $_ } } | % { @{ StartDate = $_.StartDate; EndDate = $_.EndDate; IssuesReported = (az boards query --wiql="SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Customer Feedback' AND [Custom.FeedbackSource] <> 'Star rating verbatim' AND [System.CreatedDate] < '$($_.EndDate.ToString("MM/dd/yyyy"))' AND [System.CreatedDate] >= '$($_.StartDate.ToString("MM/dd/yyyy"))' AND [System.AreaPath] UNDER 'Microsoft Learn\Customer Feedback' ORDER BY [System.Id] DESC" | ConvertFrom-Json | Measure-Object | % { $_.Count }) } }

# Get the total issues-closed count for each week for most of the last year
1..5 | % { (Get-Date).AddDays((-1 * (Get-Date).DayOfWeek.Value__) + 1).Date.AddDays($_ * -7) } | % { @{ StartDate = $_.AddDays(-7); EndDate = $_ } } | % { @{ StartDate = $_.StartDate; EndDate = $_.EndDate; IssuesReported = (az boards query --wiql="SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Customer Feedback' AND [Custom.FeedbackSource] <> 'Star rating verbatim' AND [Microsoft.VSTS.Common.ClosedDate] < '$($_.EndDate.ToString("MM/dd/yyyy"))' AND [Microsoft.VSTS.Common.ClosedDate] >= '$($_.StartDate.ToString("MM/dd/yyyy"))' AND [System.AreaPath] UNDER 'Microsoft Learn\Customer Feedback' ORDER BY [System.Id] DESC" | ConvertFrom-Json | Measure-Object | % { $_.Count }) } }

# Get total live modules (sometimes different from value scraped by other internal tooling from the GitHub repo)
# FAIL: maxes at 1000 items via query system.
1..5 | % { (Get-Date).AddDays((-1 * (Get-Date).DayOfWeek.Value__) + 1).Date.AddDays($_ * -7) } | % { @{ StartDate = $_.AddDays(-7); EndDate = $_ } } | % { @{ StartDate = $_.StartDate; EndDate = $_.EndDate; IssuesReported = (az boards query --wiql="SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Module' AND NOT [System.State] IN ('Declined', 'Removed')
AND NOT [System.State] IN ('Approved', 'Blocked', 'Canceled', 'In Progress', 'Proposed') AND [Custom.PublishedDate] <= @today
AND [Custom.PublishedDate] <> '' AND [Custom.PublishedDate] < '$($_.EndDate.ToString("MM/dd/yyyy"))' AND [Custom.PublishedDate] >= '$($_.StartDate.ToString("MM/dd/yyyy"))' ORDER BY [System.Id] DESC" | ConvertFrom-Json | Measure-Object | % { $_.Count }) } }

# Open module count
# FAIL: maxes out at 1000 items via query system
az boards query --wiql="SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Module' AND [System.State] NOT IN ('Declined', 'Removed') AND [System.State] NOT IN ('Approved', 'Blocked', 'Canceled', 'In Progress', 'Proposed') AND [Custom.PublishedDate] <= @today AND [Custom.PublishedDate] <> '' ORDER BY [System.Id] DESC" | ConvertFrom-Json | Measure-Object | % { $_.Count }

## NOTE: Due to a bug in the `az boards` command, your PowerShell highlighting colors seem to get messed up after some queries. Running this will reset them to normal.
[Console]::ResetColor()

# Loop requests over a continuation token
# NOTE: Because the Azure CLI doesn't handle large Boards queries well (constrained to first 1k results), doesn't acknowledge the continuation token, and doesn't handle queries for counts, getting a large query result count requires looping over the API request (with an access token) using any continuation token repeatedly.
$azdoOrg = [uri]::EscapeDataString("ceapex")
# $azdoProject = [uri]::EscapeDataString("Microsoft Learn")
${Env:AzDOPersonalToken} = (Read-Host -Prompt "What Azure DevOps access token do you want to use?")
$auth =  
[Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":${Env:AzDOPersonalToken}"))

$headers = @{}
$headers.Add("Content-Type", "application/json")
$headers.Add("Authorization", "Basic $auth")
$continuationToken = "" # Start without one; handled in loop
$uri = "https://dev.azure.com/$azdoOrg/_apis/wit/wiql?api-version=6.0" + "&`$top=500" #$azdoProject/

# do {
    if ($continuationToken -ne "") {
        if ($headers.ContainsKey("x-ms-continuationtoken")) {
            $headers.Add("x-ms-continuationtoken", $continuationToken)
        }
        else {
            $headers["x-ms-continuationtoken"] = $continuationToken;
        }
    }
    Write-Host $headers
    $body = "{`"query`": `"SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = 'Microsoft Learn' AND [System.WorkItemType] = 'Customer Feedback' AND [Custom.FeedbackSource] <> 'Star rating verbatim' AND [System.AreaPath] UNDER 'Microsoft Learn\Customer Feedback' AND NOT [System.State] IN ('Closed','Declined') ORDER BY [System.ChangedDate] DESC`"}"
    # Some other fields: [System.WorkItemType], [System.Title], [System.State], [System.AreaPath], [System.IterationPath], [System.Tags], [System.AssignedTo]

    # $responseHeaders
    $result = Invoke-RestMethod -Uri $uri -Headers $headers -Body $body -Method Post -ResponseHeadersVariable responseHeaders
    # try { Invoke-RestMethod -Uri $uri -Headers $headers -Body $body -Method Post } catch { $_.Exception.Response.Headers.ToString() }
    Write-Host $result.workItems
    Write-Host ($result.workItems | Measure-Object | % { $_.Count })

    # $result = @( $TestRuns | Select-Object -ExpandProperty
    # decoratedAuditLogEntries | 
    # Where-Object { $_.actionId -eq 'Git.RepositoryCreated' } |
    # Select-Object actorDisplayName, ProjectName, actionId, details, 
    # timestamp )

    $continuationToken = $result.continuationToken 
    Write-Host $continuationToken

    # $result | Export-Csv "/data.csv" -Append
# } while ($null -ne $continuationToken)