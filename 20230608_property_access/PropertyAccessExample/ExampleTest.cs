using System.Diagnostics;
using System.Reflection;
using Xunit;
using Xunit.Abstractions;

namespace PropertyAccessExample
{
    public class ExampleTest
    {
        private const int TestCount = 3;

        private ITestOutputHelper _output;

        public ExampleTest(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void Test()
        {
            var sw = new Stopwatch();
            var list = TestEntity.CreateTestEntityList(1_000_000);

            // 評価対象のラムダ式
            var testType = new (string, Func<IEnumerable<TestEntity>, IEnumerable<string>>)[]
            {
                ("switch", e => GetValuesBySwitch(list)),
                ("temp dic", e => GetValuesByTempDic(list)),
                ("ref dic", e => GetValuesByReflectionDic(list)),
                ("lamda dic", e => GetValuesByLambdaDic(list)),
                ("lamda list", e => GetValuesByLambdaList(list))
            };

            // 各評価対象を複数回実行して処理時間を集計
            var sum = new long[testType.Length];
            for (var i = 0; i < TestCount; i++)
            {
                IEnumerable<string>? expectedList = null;
                for (var j = 0; j < testType.Length; j++)
                {
                    GC.Collect();
                    sw.Restart();
                    var typeFunc = testType[j].Item2;
                    var resultList = typeFunc(list);
                    sw.Stop();
                    sum[j] += sw.ElapsedMilliseconds;

                    expectedList ??= resultList;
                    Assert.Equal(expectedList, resultList);
                }
            }

            // 評価対象毎に、集計した処理時間の平均を出力
            for (var i = 0; i < testType.Length; i++)
            {
                var typeName = testType[i].Item1;
                _output.WriteLine("({0,-10}): {1,6:#,#} [ms]", typeName, sum[i] / testType.Length);
            }
        }


        // ==================================================

        public List<string> GetValuesBySwitch(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                string val;
                switch (entity.Selection)
                {
                    case "Prop01": val = entity.Prop01; break;
                    case "Prop02": val = entity.Prop02; break;
                    case "Prop03": val = entity.Prop03; break;
                    case "Prop04": val = entity.Prop04; break;
                    case "Prop05": val = entity.Prop05; break;
                    case "Prop06": val = entity.Prop06; break;
                    case "Prop07": val = entity.Prop07; break;
                    case "Prop08": val = entity.Prop08; break;
                    case "Prop09": val = entity.Prop09; break;
                    case "Prop10": val = entity.Prop10; break;
                    case "Prop11": val = entity.Prop11; break;
                    case "Prop12": val = entity.Prop12; break;
                    case "Prop13": val = entity.Prop13; break;
                    case "Prop14": val = entity.Prop14; break;
                    case "Prop15": val = entity.Prop15; break;
                    case "Prop16": val = entity.Prop16; break;
                    case "Prop17": val = entity.Prop17; break;
                    case "Prop18": val = entity.Prop18; break;
                    case "Prop19": val = entity.Prop19; break;
                    case "Prop20": val = entity.Prop20; break;
                    case "Prop21": val = entity.Prop21; break;
                    case "Prop22": val = entity.Prop22; break;
                    case "Prop23": val = entity.Prop23; break;
                    case "Prop24": val = entity.Prop24; break;
                    case "Prop25": val = entity.Prop25; break;
                    case "Prop26": val = entity.Prop26; break;
                    case "Prop27": val = entity.Prop27; break;
                    case "Prop28": val = entity.Prop28; break;
                    case "Prop29": val = entity.Prop29; break;
                    case "Prop30": val = entity.Prop30; break;
                    default:
                        throw new InvalidOperationException();
                }
                list.Add(val);
            }
            return list;
        }

        // ==================================================

        public List<string> GetValuesByTempDic(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var val = new Dictionary<string, string>
                {
                    ["Prop01"] = entity.Prop01,
                    ["Prop02"] = entity.Prop02,
                    ["Prop03"] = entity.Prop03,
                    ["Prop04"] = entity.Prop04,
                    ["Prop05"] = entity.Prop05,
                    ["Prop06"] = entity.Prop06,
                    ["Prop07"] = entity.Prop07,
                    ["Prop08"] = entity.Prop08,
                    ["Prop09"] = entity.Prop09,
                    ["Prop10"] = entity.Prop10,
                    ["Prop11"] = entity.Prop11,
                    ["Prop12"] = entity.Prop12,
                    ["Prop13"] = entity.Prop13,
                    ["Prop14"] = entity.Prop14,
                    ["Prop15"] = entity.Prop15,
                    ["Prop16"] = entity.Prop16,
                    ["Prop17"] = entity.Prop17,
                    ["Prop18"] = entity.Prop18,
                    ["Prop19"] = entity.Prop19,
                    ["Prop20"] = entity.Prop20,
                    ["Prop21"] = entity.Prop21,
                    ["Prop22"] = entity.Prop22,
                    ["Prop23"] = entity.Prop23,
                    ["Prop24"] = entity.Prop24,
                    ["Prop25"] = entity.Prop25,
                    ["Prop26"] = entity.Prop26,
                    ["Prop27"] = entity.Prop27,
                    ["Prop28"] = entity.Prop28,
                    ["Prop29"] = entity.Prop29,
                    ["Prop30"] = entity.Prop30
                }[entity.Selection];
                list.Add(val);
            };
            return list;
        }

        // ==================================================

        public List<string> GetValuesByReflectionDic(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var propInfo = refDic[entity.Selection];
                var val = propInfo?.GetValue(entity)?.ToString() ?? "";
                list.Add(val);
            }
            return list;
        }

        private Dictionary<string, PropertyInfo?> refDic = new()
        {
            ["Prop01"] = typeof(TestEntity).GetProperty("Prop01"),
            ["Prop02"] = typeof(TestEntity).GetProperty("Prop02"),
            ["Prop03"] = typeof(TestEntity).GetProperty("Prop03"),
            ["Prop04"] = typeof(TestEntity).GetProperty("Prop04"),
            ["Prop05"] = typeof(TestEntity).GetProperty("Prop05"),
            ["Prop06"] = typeof(TestEntity).GetProperty("Prop06"),
            ["Prop07"] = typeof(TestEntity).GetProperty("Prop07"),
            ["Prop08"] = typeof(TestEntity).GetProperty("Prop08"),
            ["Prop09"] = typeof(TestEntity).GetProperty("Prop09"),
            ["Prop10"] = typeof(TestEntity).GetProperty("Prop10"),
            ["Prop11"] = typeof(TestEntity).GetProperty("Prop11"),
            ["Prop12"] = typeof(TestEntity).GetProperty("Prop12"),
            ["Prop13"] = typeof(TestEntity).GetProperty("Prop13"),
            ["Prop14"] = typeof(TestEntity).GetProperty("Prop14"),
            ["Prop15"] = typeof(TestEntity).GetProperty("Prop15"),
            ["Prop16"] = typeof(TestEntity).GetProperty("Prop16"),
            ["Prop17"] = typeof(TestEntity).GetProperty("Prop17"),
            ["Prop18"] = typeof(TestEntity).GetProperty("Prop18"),
            ["Prop19"] = typeof(TestEntity).GetProperty("Prop19"),
            ["Prop20"] = typeof(TestEntity).GetProperty("Prop20"),
            ["Prop21"] = typeof(TestEntity).GetProperty("Prop21"),
            ["Prop22"] = typeof(TestEntity).GetProperty("Prop22"),
            ["Prop23"] = typeof(TestEntity).GetProperty("Prop23"),
            ["Prop24"] = typeof(TestEntity).GetProperty("Prop24"),
            ["Prop25"] = typeof(TestEntity).GetProperty("Prop25"),
            ["Prop26"] = typeof(TestEntity).GetProperty("Prop26"),
            ["Prop27"] = typeof(TestEntity).GetProperty("Prop27"),
            ["Prop28"] = typeof(TestEntity).GetProperty("Prop28"),
            ["Prop29"] = typeof(TestEntity).GetProperty("Prop29"),
            ["Prop30"] = typeof(TestEntity).GetProperty("Prop30")
        };

        // ==================================================

        public List<string> GetValuesByLambdaDic(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var getter = lambdaDic[entity.Selection];
                list.Add(getter(entity));
            }
            return list;
        }

        private readonly Dictionary<string, Func<TestEntity, string>> lambdaDic = new()
        {
            ["Prop01"] = e => e.Prop01,
            ["Prop02"] = e => e.Prop02,
            ["Prop03"] = e => e.Prop03,
            ["Prop04"] = e => e.Prop04,
            ["Prop05"] = e => e.Prop05,
            ["Prop06"] = e => e.Prop06,
            ["Prop07"] = e => e.Prop07,
            ["Prop08"] = e => e.Prop08,
            ["Prop09"] = e => e.Prop09,
            ["Prop10"] = e => e.Prop10,
            ["Prop11"] = e => e.Prop11,
            ["Prop12"] = e => e.Prop12,
            ["Prop13"] = e => e.Prop13,
            ["Prop14"] = e => e.Prop14,
            ["Prop15"] = e => e.Prop15,
            ["Prop16"] = e => e.Prop16,
            ["Prop17"] = e => e.Prop17,
            ["Prop18"] = e => e.Prop18,
            ["Prop19"] = e => e.Prop19,
            ["Prop20"] = e => e.Prop20,
            ["Prop21"] = e => e.Prop21,
            ["Prop22"] = e => e.Prop22,
            ["Prop23"] = e => e.Prop23,
            ["Prop24"] = e => e.Prop24,
            ["Prop25"] = e => e.Prop25,
            ["Prop26"] = e => e.Prop26,
            ["Prop27"] = e => e.Prop27,
            ["Prop28"] = e => e.Prop28,
            ["Prop29"] = e => e.Prop29,
            ["Prop30"] = e => e.Prop30
        };

        // ==================================================

        private readonly List<Func<TestEntity, string>> lambdaList = new()
        {
            e => e.Prop01,
            e => e.Prop02,
            e => e.Prop03,
            e => e.Prop04,
            e => e.Prop05,
            e => e.Prop06,
            e => e.Prop07,
            e => e.Prop08,
            e => e.Prop09,
            e => e.Prop10,
            e => e.Prop11,
            e => e.Prop12,
            e => e.Prop13,
            e => e.Prop14,
            e => e.Prop15,
            e => e.Prop16,
            e => e.Prop17,
            e => e.Prop18,
            e => e.Prop19,
            e => e.Prop20,
            e => e.Prop21,
            e => e.Prop22,
            e => e.Prop23,
            e => e.Prop24,
            e => e.Prop25,
            e => e.Prop26,
            e => e.Prop27,
            e => e.Prop28,
            e => e.Prop29,
            e => e.Prop30
        };

        public List<string> GetValuesByLambdaList(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var getter = lambdaList[(int)entity.Selction2];
                list.Add(getter(entity));
            }
            return list;
        }

    }


}