using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace KyrsachWpf
{
    /// <summary>
    /// Логика взаимодействия для EmpCheack.xaml
    /// </summary>
    public partial class EmpCheack : Window
    {
        public long id;

        public EmpCheack(long ID)
        {
            InitializeComponent();

            id = ID;

            Getdata();
        }

        public void Getdata()
        {
            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();

            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;
            NpgsqlCommand command = new NpgsqlCommand("select * from fullCheak", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {

                    DataItem item = new DataItem();
                    item.Column1 = reader.GetInt64(0);
                    item.Column2 = reader.GetInt64(1);
                    item.Column3 = reader.GetString(2);
                    item.Column4 = reader.GetString(3);
                    item.Column5 = reader.GetString(4);
                    item.Column6 = reader.GetString(5);
                    item.Column7 = reader.GetDecimal(6);
                    Tablichka.Items.Add(item);
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }
        }

        private class DataItem
        {
            public long Column1 { get; set; }
            public long Column2 { get; set; }
            public string Column3 { get; set; }
            public string Column4 { get; set; }
            public string Column5 { get; set; }
            public string Column6 { get; set; }
            public Decimal Column7 { get; set; }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            AddCheack addCheack = new AddCheack(id);
            addCheack.Show();
        }
    }
}
