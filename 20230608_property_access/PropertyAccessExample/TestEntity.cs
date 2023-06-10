using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PropertyAccessExample
{
    public class TestEntity
    {
        public string Selection { get; set; }

        public PropType Selction2 { get; set; }

        public string Prop01 { get; set; }
        public string Prop02 { get; set; }
        public string Prop03 { get; set; }
        public string Prop04 { get; set; }
        public string Prop05 { get; set; }
        public string Prop06 { get; set; }
        public string Prop07 { get; set; }
        public string Prop08 { get; set; }
        public string Prop09 { get; set; }
        public string Prop10 { get; set; }
        public string Prop11 { get; set; }
        public string Prop12 { get; set; }
        public string Prop13 { get; set; }
        public string Prop14 { get; set; }
        public string Prop15 { get; set; }
        public string Prop16 { get; set; }
        public string Prop17 { get; set; }
        public string Prop18 { get; set; }
        public string Prop19 { get; set; }
        public string Prop20 { get; set; }
        public string Prop21 { get; set; }
        public string Prop22 { get; set; }
        public string Prop23 { get; set; }
        public string Prop24 { get; set; }
        public string Prop25 { get; set; }
        public string Prop26 { get; set; }
        public string Prop27 { get; set; }
        public string Prop28 { get; set; }
        public string Prop29 { get; set; }
        public string Prop30 { get; set; }

        public static IEnumerable<TestEntity> CreateTestEntityList(int size)
        {
            var random = new Random();
            var list = new List<TestEntity>();
            for (int i = 0; i < size; i++)
            {
                var index = random.Next() % 30;
                var propNo = index + 1;
                var prefix = string.Format("[{0:00000}]-", i);
                list.Add(new TestEntity
                {
                    Selection = "Prop" + propNo.ToString("00"),
                    Selction2 = (PropType)index,
                    Prop01 = prefix + "value01",
                    Prop02 = prefix + "value02",
                    Prop03 = prefix + "value03",
                    Prop04 = prefix + "value04",
                    Prop05 = prefix + "value05",
                    Prop06 = prefix + "value06",
                    Prop07 = prefix + "value07",
                    Prop08 = prefix + "value08",
                    Prop09 = prefix + "value09",
                    Prop10 = prefix + "value10",
                    Prop11 = prefix + "value11",
                    Prop12 = prefix + "value12",
                    Prop13 = prefix + "value13",
                    Prop14 = prefix + "value14",
                    Prop15 = prefix + "value15",
                    Prop16 = prefix + "value16",
                    Prop17 = prefix + "value17",
                    Prop18 = prefix + "value18",
                    Prop19 = prefix + "value19",
                    Prop20 = prefix + "value20",
                    Prop21 = prefix + "value21",
                    Prop22 = prefix + "value22",
                    Prop23 = prefix + "value23",
                    Prop24 = prefix + "value24",
                    Prop25 = prefix + "value25",
                    Prop26 = prefix + "value26",
                    Prop27 = prefix + "value27",
                    Prop28 = prefix + "value28",
                    Prop29 = prefix + "value29",
                    Prop30 = prefix + "value30"
                });
            }
            return list;
        }
    }

    public enum PropType
    {
        Prop01 = 0,
        Prop02,
        Prop03,
        Prop04,
        Prop05,
        Prop06,
        Prop07,
        Prop08,
        Prop09,
        Prop10,
        Prop11,
        Prop12,
        Prop13,
        Prop14,
        Prop15,
        Prop16,
        Prop17,
        Prop18,
        Prop19,
        Prop20,
        Prop21,
        Prop22,
        Prop23,
        Prop24,
        Prop25,
        Prop26,
        Prop27,
        Prop28,
        Prop29,
        Prop30
    }
}
