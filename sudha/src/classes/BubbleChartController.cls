public with sharing class BubbleChartController{
    public String deafultFromDate { get; set; }
    public String defaultThroughDate { get; set; }

    private static final String REPORT_ID = '00O28000003H60m';

    public BubbleChartController() {
        // Default to the current year.
        // These instance variables are only used to
        // populate the default values on the inputs.
        Integer year = Date.today().year();
        deafultFromDate = String.valueOf( Date.newInstance(year, 1, 1) );
        defaultThroughDate = String.valueOf( Date.newInstance(year + 1, 1, 1).addDays(-1) );
    }

    @RemoteAction
    public static List<Bubble> getUpdatedBubbles(String fromDate, String throughDate) {
        Reports.ReportResults results = runReport(fromDate, throughDate);  
        List<Bubble> bubbles = createBubbles(results);
        return bubbles;
    }

    public static Reports.ReportResults runReport(String fromDate, String throughDate) {
        Reports.ReportMetadata options = getReportOptions(fromDate, throughDate);
        Reports.ReportResults results = Reports.ReportManager.runReport(REPORT_ID, options);
        return results;
    }

    private static Reports.ReportMetadata getReportOptions(String fromDate, String throughDate) {
        List<Reports.ReportFilter> reportFilters = new List<Reports.ReportFilter>();
        Reports.ReportFilter fromFilter = new Reports.ReportFilter();
        fromFilter.setColumn('CLOSE_DATE');
        fromFilter.setOperator('greaterOrEqual');
        fromFilter.setValue(fromDate);
        reportFilters.add(fromFilter);

        Reports.ReportFilter toFilter = new Reports.ReportFilter();
        toFilter.setColumn('CLOSE_DATE');
        toFilter.setOperator('lessOrEqual');
        toFilter.setValue(throughDate);
        reportFilters.add(toFilter);

        Reports.ReportMetadata opts = new Reports.ReportMetadata();
        opts.setReportFilters(reportFilters);

        return opts;
    }

    private static List<Bubble> createBubbles(Reports.ReportResults results) {          
        // Get the index of each aggregate from the metadata. 
        // Will be used to get values from the fact map aggregates.
        Integer amountIdx, rowCountIdx;
        List<String> aggColNames = results.getReportMetadata().getAggregates();
        for (Integer i = 0, cnt = aggColNames.size(); i < cnt; i++) {
            String aggColName = aggColNames.get(i);
            if (aggColName == 's!AMOUNT') {
                amountIdx = i;
            } else if (aggColName == 'RowCount') {
                rowCountIdx = i;
            }
        }

        Reports.Dimension groupingsDown = results.getGroupingsDown();
        Map<String, Reports.ReportFact> factMap = results.getFactMap(); 
        List<Bubble> bubbles = new List<Bubble>();

        for (Reports.GroupingValue grouping1 : groupingsDown.getGroupings()) {
           String stage = (String) grouping1.getValue();

            for (Reports.GroupingValue grouping2 : grouping1.getGroupings()) {
                Decimal probability = (Decimal) grouping2.getValue();

                Reports.ReportFact fact = factMap.get(grouping2.getKey() + '!T');
                Decimal amount = (Decimal) fact.getAggregates().get(amountIdx).getValue();
                Decimal rowCount = (Decimal) fact.getAggregates().get(rowCountIdx).getValue();

                bubbles.add( new Bubble(stage, probability, amount, rowCount.intValue()) );
            }
        }
        return bubbles;
    }

    class Bubble {
        public String stage { get; set; }
        public Decimal probability { get; set; }
        public Decimal amount { get; set; }
        public Integer rowCount { get; set; }

        public Bubble(String s, Decimal p, Decimal a, Integer rc) {
            stage = s;
            probability = p;
            amount = a;
            rowCount = rc;
        }
    }
}