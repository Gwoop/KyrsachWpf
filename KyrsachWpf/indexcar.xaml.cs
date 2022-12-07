using Npgsql;
using System;
using System.Collections.Generic;
using System.IO;
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
    /// Логика взаимодействия для indexcar.xaml
    /// </summary>
    public partial class indexcar : Window
    {
        public long Log;
        public long ID;

        public indexcar(long id, long login)
        {
            InitializeComponent();
            Log = login;
            ID = id;

            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();

            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;

            NpgsqlCommand command = new NpgsqlCommand($"select * from fullcars where id = {id}", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Model.Content = reader.GetString(1);
                    Mark.Content = reader.GetString(3);
                    Konf.Content = reader.GetString(4);


                    //byte[] bytes = Encoding.ASCII.GetBytes(reader.GetString(2));
                    
                    //MemoryStream memoryStream = new MemoryStream(bytes);
                    //Image.FromStream(memoryStream);

                    //im.Source = reader.GetString(1);
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Cars cars = new Cars(Log);
            this.Close();
            cars.Show();
        }


        private void Button_Click1(object sender, RoutedEventArgs e)
        {
            long idClient = 0;

            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();

            NpgsqlCommand command = new NpgsqlCommand("select * from Client;", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    if (reader.GetInt64(7) == Log)
                    {
                        idClient = reader.GetInt64(7);
                    }
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }

            npgSqlConnection.Open();

            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;

    
            DateTime thisDay = DateTime.Today;
            cmd.CommandText = $"insert into Cheak(Dates,Client_ID,Model_ID) values ('{thisDay.ToString("dd.MM.yyyy")}',{idClient},{ID});";
            cmd.ExecuteNonQuery();

            MessageBox.Show("Заказ оформлен, обратитесь к сотруднику для оплаты и получению машины");

        }
    }
}
