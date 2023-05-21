using MemoryLoadWeb.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;
using System.Text;

namespace MemoryLoadWeb.Controllers
{
    public class MemoryLoadController : Controller
    {
        public const int DataUnitSize = 512 * 1024 * 1024; // 512 [MB]

        private const int InsertCount = 1000;

        private static readonly List<byte[]> _staticLoadList = new();

        private readonly List<byte[]> _localLoadList = new();

        private TestDbContext _dbContext;

        public MemoryLoadController(TestDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public IActionResult Index()
        {
            return View();
        }

        public IActionResult AddGlobalLoad()
        {
            _staticLoadList.Add(new byte[DataUnitSize]);
            return View(nameof(Index));
        }

        public IActionResult AddLocalLoad()
        {
            _localLoadList.Add(new byte[DataUnitSize]);
            _localLoadList.Add(new byte[DataUnitSize]);
            return View(nameof(Index));
        }

        public IActionResult RaiseOutOfMemory()
        {
            var buf = "a";
            for (int i = 0; i < 10_000; i++)
                buf += buf; // OutOfMemoryException

            return View(nameof(Index));
        }

        public async Task<IActionResult> InitHugeData()
        {
            // 性能向上のために生SQLで複数行INSERTを使用
            await _dbContext.Database.ExecuteSqlRawAsync("truncate table Employee");
            for (var i = 0; i < 10; i++)
            {
                var sb = new StringBuilder();
                sb.Append("insert Employee(Name, Department, Address, Birthday) values");
                for(int j=0; j< InsertCount; j++)
                {
                    var no = i * InsertCount + j;
                    sb.Append($"('test-{no}', '{no % 10000}', 'Address-{no}', getdate()),");
                }
                sb.Remove(sb.Length-1, 1); // delete last ','
                await _dbContext.Database.ExecuteSqlRawAsync(sb.ToString());
            }
            return View(nameof(Index));
        }

        public async Task<IActionResult> SearchHugeDataAndWait()
        {
            var resultList = await _dbContext.Employee.ToListAsync();
            //_dbContext.ChangeTracker.Clear();

            // dummy of "wait for Web response"
            Thread.Sleep(30 * 1000);

            return View(nameof(Index));
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}