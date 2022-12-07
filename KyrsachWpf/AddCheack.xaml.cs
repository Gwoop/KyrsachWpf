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
    /// Логика взаимодействия для AddCheack.xaml
    /// </summary>
    public partial class AddCheack : Window
    {
        public long ID;

        public AddCheack(long id)
        {
            InitializeComponent();

            ID = id;

            Getdata();
        }


        public void Getdata()
        {
            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();


            NpgsqlCommand command = new NpgsqlCommand("select * from users", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    if (reader.GetInt64(8) == ID)
                    {
                        idEmp = reader.GetInt64(0);
                    }
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
            public string Column2 { get; set; }
            public string Column3 { get; set; }
            public string Column4 { get; set; }
            public string Column5 { get; set; }
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();
            long idEmp = 0;


            NpgsqlCommand command = new NpgsqlCommand("select * from Model", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    if (reader.GetInt64(8) == ID)
                    {
                        idEmp = reader.GetInt64(0);

                        cm.ItemsSource = B1;
                        cm.DisplayMemberPath = "Email";
                        cm.SelectedValuePath = "ID_Staff";
                    }
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }

            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;

            DateTime thisDay = DateTime.Today;
            cmd.CommandText = $"insert into Cheak(Dates,Client_ID,Model_ID,Employee_ID) values ('{thisDay.ToString("dd.MM.yyyy")}',{idClient},{Model_ID},{ID});";
            cmd.ExecuteNonQuery();
        }
    }
}
