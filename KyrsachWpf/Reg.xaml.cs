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
    /// Логика взаимодействия для Reg.xaml
    /// </summary>
    public partial class Reg : Window
    {
        public Reg()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();

            long id = 0;

            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;


            cmd.CommandText = $"insert into Users(Login,Passwor,Roles_ID) values('{login.Text}','{pas.Text}',2); ";
            cmd.ExecuteNonQuery();


            NpgsqlCommand command = new NpgsqlCommand("select * from users", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    if (reader.GetString(1) == login.Text && reader.GetString(2) == pas.Text)
                    {
                        id = reader.GetInt64(0);
                    }
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }

            npgSqlConnection.Open();
            cmd.CommandText = $"insert into Client(first_Name_c,Name_c,Middle_Name_c,Date_Bithdais,Client_Number,Client_Email,User_ID) values('{first.Text}', '{name.Text}', '{mid.Text}', '{picer.Text}','{numb.Text}','{email.Text}',{id});";
            cmd.ExecuteNonQuery();
            npgSqlConnection.Close();

            MainWindow mainWindow = new MainWindow();
            this.Close();
            mainWindow.Show();

        }
    }
}
