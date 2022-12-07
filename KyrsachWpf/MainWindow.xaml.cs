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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace KyrsachWpf
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
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
                   
                    if (reader.GetString(1) == Login.Text && reader.GetString(2) == Password.Text)
                    {
                        if(reader.GetInt64(3) == 1)
                        {
                            MessageBox.Show("Админ");
                        }
                        else if (reader.GetInt64(3) == 2)
                        {
                            MessageBox.Show("Клиент");
                            Cars cars = new Cars(reader.GetInt64(0));
                            this.Close();
                            npgSqlConnection.Close();
                            cars.Show();
                            break;
                            
                        }
                        else if (reader.GetInt64(3) == 3)
                        {
                            MessageBox.Show("Сотрудник");
                            EmpCheack empCheack = new EmpCheack(reader.GetInt64(0));
                            this.Close();
                            npgSqlConnection.Close();
                            empCheack.Show();
                            break;

                        }
                    }
                    //else
                    //{
                    //    MessageBox.Show("Ошибка входа. Проверьте вводимые данные");
                    //}
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            Soiskatel soiskatel = new Soiskatel();
            this.Close();
            soiskatel.Show();
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            Reg reg = new Reg();
            this.Close();
            reg.Show();
        }
    }
}
