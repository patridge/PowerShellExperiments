$ModuleProductsUnique = $ModuleProducts | % { $_.Products.Trim("'") -Split "," } | Sort-Object | Get-Unique

$ModuleProducts = Import-Csv -Path .\productdata.csv
$ProductsAndCounts = $ModuleProducts | % { $_.Products.Trim("'") -Split "," } | Sort-Object | Get-Unique | % { [pscustomobject]@{ Product = $_; FeedbackCount = 0 } }
$Last3MonthsFeedback = Import-Csv -Path '.\`[wip, for Monica`] Customer Feedback, closed last 3 months.csv' | Sort-Object -Property UID
# NOTE: feedback UIDs are likely unit UIDs rather than module UIDs (and sometimes they don't contain the module UID as a prefix).
$FeedbackWithModuleUidAndProducts = @()

$Last3MonthsFeedback | ForEach-Object { #| Select-Object -First 15 
    $Feedback = $_
    $ModuleUid = $ModuleProducts | ? { $Feedback.UID.StartsWith("$($_.UID).")-or $Feedback.UID -eq $_.UID }

    ## TODO: Manually map these not-found unit UIDs
    # learn.azure.query-data-sentinel.4-query-data
    # learn.azure.troubleshoot-inbound-network-connectivity-azure-load-balancer.diagnose-issues-by-reviewing-configurations-and-metrics
    # learn.intro-to-compliance.2-azure-policy -> learn.intro-to-governance?
    # learn.manage-vms-with-azure-cli-data.5-sizing-vms

    # Write-Host "$($Feedback.UID); $($ModuleUid.UID); $($ModuleUid.Products.Trim("'") -Split ",")"
    if ($ModuleUid -eq $null) {
        # Write-Host $Feedback
        continue
    }

    $FeedbackWithModuleUidAndProducts = $FeedbackWithModuleUidAndProducts + [pscustomobject]@{ FeedbackUid = $Feedback.UID; ModuleUids = $ModuleUid.UID; Products = $ModuleUid.Products.Trim("'") -Split "," }
}

foreach ($feedbackItem in $FeedbackWithModuleUidAndProducts) {
    foreach ($product in $feedbackItem.Products) {
        $productAndCount = $ProductsAndCounts | ? { $_.Product -eq $product }
        # Write-Host $productAndCount
        $productAndCount.FeedbackCount = $productAndCount.FeedbackCount + 1
    }
}

$ProductsAndCounts | ? { $_.FeedbackCount -gt 0 } | Sort-Object -Property FeedbackCount -Descending


$Last1MonthsFeedback = Import-Csv -Path '.\`[wip, for Monica`] Customer Feedback, closed last month.csv' | Sort-Object -Property UID
$FeedbackWithModuleUidAndProducts = @()

$Last1MonthsFeedback | ForEach-Object { #| Select-Object -First 15 
    $Feedback = $_
    $ModuleUid = $ModuleProducts | ? { $Feedback.UID.StartsWith("$($_.UID).")-or $Feedback.UID -eq $_.UID }

    ## TODO: Manually map these not-found unit UIDs
    # learn.azure.query-data-sentinel.4-query-data
    # learn.azure.troubleshoot-inbound-network-connectivity-azure-load-balancer.diagnose-issues-by-reviewing-configurations-and-metrics
    # learn.intro-to-compliance.2-azure-policy -> learn.intro-to-governance?
    # learn.manage-vms-with-azure-cli-data.5-sizing-vms

    # Write-Host "$($Feedback.UID); $($ModuleUid.UID); $($ModuleUid.Products.Trim("'") -Split ",")"
    if ($ModuleUid -eq $null) {
        # Write-Host $Feedback
        continue
    }

    $FeedbackWithModuleUidAndProducts = $FeedbackWithModuleUidAndProducts + [pscustomobject]@{ FeedbackUid = $Feedback.UID; ModuleUids = $ModuleUid.UID; Products = $ModuleUid.Products.Trim("'") -Split "," }
}

foreach ($feedbackItem in $FeedbackWithModuleUidAndProducts) {
    foreach ($product in $feedbackItem.Products) {
        $productAndCount = $ProductsAndCounts | ? { $_.Product -eq $product }
        # Write-Host $productAndCount
        $productAndCount.FeedbackCount = $productAndCount.FeedbackCount + 1
    }
}

$ProductsAndCounts | ? { $_.FeedbackCount -gt 0 } | Sort-Object -Property FeedbackCount -Descending



$Last3MonthsFeedbackUidsAll = $Last3MonthsFeedback | % { $_.UID } | Sort-Object | Get-Unique

#$ModuleProductsAll = $ModuleProducts | ? { $Last3MonthsFeedbackUidsAll -contains $_.UID } | % { $_.Products.Trim("'") -Split "," } | Sort-Object
#$ModuleProducts | % { [pscustomobject]@{ Product = $_.; b = 4 } }

ForEach ($ModuleProduct in $ModuleProducts) {
    
}

