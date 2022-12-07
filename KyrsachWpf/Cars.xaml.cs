using Effort.Internal.TypeGeneration;
using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
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
using static KyrsachWpf.indexcar;

namespace KyrsachWpf
{
    /// <summary>
    /// Логика взаимодействия для Cars.xaml
    /// </summary>
    public partial class Cars : Window
    {

        public long Log;


        public Cars(long login)
        {
            InitializeComponent();
            Getdata();

            Log = login;

        }

        public void Getdata()
        {
            String connectionString = "Server=localhost;Port=5432;User id=postgres;Password=1234;Database=Kyrsach;";
            NpgsqlConnection npgSqlConnection = new NpgsqlConnection(connectionString);
            npgSqlConnection.Open();


            using var cmd = new NpgsqlCommand();
            cmd.Connection = npgSqlConnection;


            NpgsqlCommand command = new NpgsqlCommand("select * from fullcars", npgSqlConnection);
            try
            {
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {

                    DataItem item = new DataItem();
                    item.Column1 = reader.GetInt64(0);
                    item.Column2 = reader.GetString(1);
                    item.Column3 = reader.GetString(2);
                    item.Column4 = reader.GetString(3);
                    item.Column5 = reader.GetString(4);
                    Tablichka.Items.Add(item);
                }
            }
            finally
            {
                npgSqlConnection.Close();
            }
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            
            var cellInfo = Tablichka.SelectedCells[0];
            var content = (cellInfo.Column.GetCellContent(cellInfo.Item) as TextBlock).Text;

            //MessageBox.Show(Convert.ToString(content));
            indexcar indexcar = new indexcar(Convert.ToInt32(content),Log);
            this.Close();
            indexcar.Show();

        }

        private void DataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
         
        }


        private class DataItem
        {
            public long Column1 { get; set; }
            public string Column2 { get; set; }
            public string Column3 { get; set; }
            public string Column4 { get; set; }
            public string Column5 { get; set; }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            MainWindow mainWindow = new MainWindow();
            this.Close();
            mainWindow.Show();
        }

       
    }

}
