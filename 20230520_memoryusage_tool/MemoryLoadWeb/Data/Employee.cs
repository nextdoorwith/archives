using System.ComponentModel.DataAnnotations;

namespace MemoryLoadWeb.Data
{
    public class Employee
    {
        [Key]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public DateTime BirthDay { get; set; }
    }
}
