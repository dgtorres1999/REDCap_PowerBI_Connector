// This file contains your Data Connector logic
[Version = "1.0.0"]
section REDCap_Connector;

[DataSource.Kind="REDCap_Connector", Publish="REDCap_Connector.Publish"]
shared REDCap_Connector.Contents = Value.ReplaceType(REDCapSec, type function(
    redcap_url as (type text meta [
        Documentation.FieldCaption= "REDCap URL",
        Documentation.SampleValues= {"https://exampleredcap.com/api"}
    ]),
    token as (type text meta [
        Documentation.FieldCaption= "REDCap API Token",
        Documentation.SampleValues= {"123ABC456"}
    ]),
    content_type as (type text meta [
        Documentation.FieldCaption = "Content Type",
        Documentation.Description = "Select 'record' or 'report' to specify the type of data you want to fetch.",
        Documentation.AllowedValues = { "record", "report" }
    ]),
    report_id as (type nullable text meta [
        Documentation.FieldCaption= "Report ID (Required if Content Type is 'report')",
        Documentation.Description = "Provide the report ID if 'report' is selected as Content Type.",
        Documentation.SampleValues= {"1234"}
    ]),
    rawOrlabel as (type text meta [
        Documentation.FieldCaption = "Raw or Label",
        Documentation.AllowedValues = { "raw", "label" },
        Documentation.Description = "Specify 'raw' or 'label' for report data."
    ]), 
    rawOrlabel_Headers as (type text meta [
        Documentation.FieldCaption = "Raw or Label Headers",
        Documentation.AllowedValues = { "raw", "label" },
        Documentation.Description = "Specify 'raw' or 'label' for header names in reports."
    ]), 
    exportCheckboxLabel as (type text meta [
        Documentation.FieldCaption = "Checkbox Labels",
        Documentation.AllowedValues = { "true", "false" },
        Documentation.Description = "Indicate if checkbox labels should be used."
    ]),
    exportSurveyFields as (type text meta [
        Documentation.FieldCaption = "Export Survey Fields (Select false for 'reports')",
        Documentation.AllowedValues = { "true", "false" },
        Documentation.Description = "Indicate if survey fields should be exported for records.",
        Documentation.DefaultValue = "false"
    ]),
    exportDataAccessGroups as (type text meta [
        Documentation.FieldCaption = "Export Data Access Groups (Select false for 'reports')",
        Documentation.AllowedValues = { "true", "false" },
        Documentation.Description = "Indicate if data access groups should be exported for records.",
        Documentation.DefaultValue = "false"
    ]),
    Fields as (type nullable text meta [
        Documentation.FieldCaption = "Fields (Only for 'records')",
        Documentation.Description = "Comma-separated list of fields to include (for records)."
    ]),
    Forms as (type nullable text meta [
        Documentation.FieldCaption = "Forms (Only for 'records')",
        Documentation.Description = "Comma-separated list of forms to include (for records)."
    ]),
    Events as (type nullable text meta [
        Documentation.FieldCaption = "Events (Only for 'records')",
        Documentation.Description = "Comma-separated list of events to include (for records)."
    ])
) as any);

headers = [
    #"Accept" = "application/csv",
    #"Content-Type" = "application/x-www-form-urlencoded"
];

REDCapSec = (redcap_url as text, token as text, content_type as text, report_id as nullable text, raw_label as nullable text, raw_label_headers as nullable text, checkbox_label as nullable text, survey_fields as nullable text, export_dag as nullable text, fields as nullable text, forms as nullable text, events as nullable text) =>
    let
        myurl = redcap_url,
        mytoken = token,
        field_s = if fields is null then "" else fields,
        form_s = if forms is null then "" else forms,
        event_s = if events is null then "" else events,

        // Determine the appropriate content type (record or report)
        data_source = 
            if content_type = "report" then
                Web.Contents(myurl, [
                    Content = Text.ToBinary("token=" & mytoken & "&content=report&format=csv&report_id=" & report_id & "&type=flat&rawOrLabel=" & raw_label & "&rawOrLabelHeaders=" & raw_label_headers & "&exportCheckboxLabel=" & checkbox_label & "&returnFormat=json"),
                    Headers = headers
                ])
            else
                Web.Contents(myurl, [
                    Content = Text.ToBinary("token=" & mytoken & "&content=record&format=csv&type=flat&fields=" & field_s & "&forms=" & form_s & "&events=" & event_s & "&rawOrLabel=" & raw_label & "&rawOrLabelHeaders=" & raw_label_headers & "&exportCheckboxLabel=" & checkbox_label & "&exportSurveyFields=" & survey_fields & "&exportDataAccessGroups=" & export_dag & "&returnFormat=json"),
                    Headers = headers
                ]),

        dset = Csv.Document(data_source),
        data = Table.PromoteHeaders(dset)
    in
        data;

// Data Source Kind description
REDCap_report_records = [
    TestConnection = (dataSourcePath) => {"REDCap_report_records.Contents", dataSourcePath},
    Authentication = [ Anonymous = [] ],
    Label = "REDCap Connector Records and Reports"
];

REDCap_report_records.Icons = [
    Icon16 = { Extension.Contents("REDCap16.png"), Extension.Contents("REDCap20.png"), Extension.Contents("REDCap24.png"), Extension.Contents("REDCap32.png") },
    Icon32 = { Extension.Contents("REDCap32.png"), Extension.Contents("REDCap40.png"), Extension.Contents("REDCap48.png"), Extension.Contents("REDCap64.png") }
];

// Data Source UI publishing description
REDCap_report_records.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { "REDCap Connector Records and Reports", "Connect to REDCap Records and Reports" },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = REDCap_report_records.Icons,
    SourceTypeImage = REDCap_report_records.Icons
];
