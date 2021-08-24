local sampleOne = import '../../sample-one-mixin/mixin.libsonnet';
local sampleTwo = import '../../sample-two-mixin/mixin.libsonnet';

(sampleOne {
   _config+:: {
     sampleOneSelector: 'job="sample-one"',
     sampleOneGrafanaFolder: 'sample-one',
   },
 })
// sampleTwo {
//   _config+:: {
//     sampleTwoSelector: 'job="sample-two"',
//     sampleTwoGrafanaFolder: 'sample-two',
//   },
// }



