using System.Diagnostics;
using System.Reflection;
using Xunit;
using Xunit.Abstractions;

namespace PropertyAccessExample
{
    public class ExampleTest
    {
        /// <summary>
        /// 各方式の測定回数
        /// </summary>
        private const int TestCount = 5;

        private ITestOutputHelper _output;

        public ExampleTest(ITestOutputHelper output)
        {
            _output = output;
        }

        /// <summary>
        /// 各方式の処理時間を測定する。
        /// </summary>
        [Fact]
        public void EvaluatePerformance()
        {
            var sw = new Stopwatch();
            var list = TestEntity.CreateTestEntityList(1_000_000);

            // 各方式のラムダ式
            var testType = new (string, Func<IEnumerable<TestEntity>, IEnumerable<string>>)[]
            {
                ("switch", e => GetValuesBySwitch(list)),
                ("ref", e => GetValuesByReflection(list)),
                ("temp dic", e => GetValuesByTempDic(list)),
                ("ref dic", e => GetValuesByReflectionDic(list)),
                ("lamda dic", e => GetValuesByLambdaDic(list)),
                ("lamda list", e => GetValuesByLambdaList(list))
            };

            // 各方式を複数回実行して処理時間を集計
            // (実行順による偏りを減らすために、それぞれN回ではなく、全種類×N回ループ)
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

            // 各方式の平均処理時間を出力
            for (var i = 0; i < testType.Length; i++)
            {
                var typeName = testType[i].Item1;
                _output.WriteLine("({0,-10}): {1,6:#,#} [ms]", typeName, sum[i] / TestCount);
            }
        }


        // ==================================================

        /// <summary>
        /// switchを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        /// <exception cref="InvalidOperationException"></exception>
        public static List<string> GetValuesBySwitch(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                string val = entity.Selection switch
                {
                    "Prop01" => entity.Prop01,
                    "Prop02" => entity.Prop02,
                    "Prop03" => entity.Prop03,
                    "Prop04" => entity.Prop04,
                    "Prop05" => entity.Prop05,
                    "Prop06" => entity.Prop06,
                    "Prop07" => entity.Prop07,
                    "Prop08" => entity.Prop08,
                    "Prop09" => entity.Prop09,
                    "Prop10" => entity.Prop10,
                    "Prop11" => entity.Prop11,
                    "Prop12" => entity.Prop12,
                    "Prop13" => entity.Prop13,
                    "Prop14" => entity.Prop14,
                    "Prop15" => entity.Prop15,
                    "Prop16" => entity.Prop16,
                    "Prop17" => entity.Prop17,
                    "Prop18" => entity.Prop18,
                    "Prop19" => entity.Prop19,
                    "Prop20" => entity.Prop20,
                    "Prop21" => entity.Prop21,
                    "Prop22" => entity.Prop22,
                    "Prop23" => entity.Prop23,
                    "Prop24" => entity.Prop24,
                    "Prop25" => entity.Prop25,
                    "Prop26" => entity.Prop26,
                    "Prop27" => entity.Prop27,
                    "Prop28" => entity.Prop28,
                    "Prop29" => entity.Prop29,
                    "Prop30" => entity.Prop30,
                    _ => throw new InvalidOperationException(),
                };
                list.Add(val);
            }
            return list;
        }

        // ==================================================

        /// <summary>
        /// リフレクションを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        public static List<string> GetValuesByReflection(IEnumerable<TestEntity> entityList)
        {
            var entityType = typeof(TestEntity);
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var propInfo = entityType.GetProperty(entity.Selection);
                var val = propInfo?.GetValue(entity)?.ToString() ?? "";
                list.Add(val);
            }
            return list;
        }

        // ==================================================

        /// <summary>
        /// Dictionaryを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        public static List<string> GetValuesByTempDic(IEnumerable<TestEntity> entityList)
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

        /// <summary>
        /// リフレクションDictionaryを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        public static List<string> GetValuesByReflectionDic(IEnumerable<TestEntity> entityList)
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

        private static Dictionary<string, PropertyInfo?> refDic = new()
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

        /// <summary>
        /// ラムダ式Dictionaryを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        public static List<string> GetValuesByLambdaDic(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var getter = lambdaDic[entity.Selection];
                list.Add(getter(entity));
            }
            return list;
        }

        private static readonly Dictionary<string, Func<TestEntity, string>> lambdaDic = new()
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

        /// <summary>
        /// ラムダ式リストを使用したプロパティ値の取得方式
        /// </summary>
        /// <param name="entityList"></param>
        /// <returns></returns>
        public static List<string> GetValuesByLambdaList(IEnumerable<TestEntity> entityList)
        {
            var list = new List<string>();
            foreach (var entity in entityList)
            {
                var getter = lambdaList[(int)entity.Selction2];
                list.Add(getter(entity));
            }
            return list;
        }

        private static readonly List<Func<TestEntity, string>> lambdaList = new()
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
    }


}