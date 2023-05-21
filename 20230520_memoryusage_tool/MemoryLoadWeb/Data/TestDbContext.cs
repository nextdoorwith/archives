using MemoryLoadWeb.Data;
using Microsoft.EntityFrameworkCore;

namespace MemoryLoadWeb
{
    public class TestDbContext : DbContext
    {
        // 接続文字列はappsettings.Development.jsonで定義
        // (Program.csを参照)

        public TestDbContext(DbContextOptions<TestDbContext> options) : base(options) { }

        public DbSet<Employee> Employee { get; set; }
    }
}
