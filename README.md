# HealthKit_data_plot
Use MATLAB to plot HealthKit data converted by [nabelekt/HealthKit_data_convert](https://github.com/nabelekt/HealthKit_data_convert).

For an explination of record types, see [Apple's documentation](https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier). Note that because of the way that watchOS/iOS measures and stores many of these recordtypes, it does not make much sense to plot their individual data points. For example, the 'DistanceWalkingRunning' record type records movement over relatively short and varyingtime periods. To resolve this issue, support for some type of data aggregation (such as summing all of the data points over one day) is planned for some time in the future.

This project is under development. Usage instructions and screenshots comming soon.
