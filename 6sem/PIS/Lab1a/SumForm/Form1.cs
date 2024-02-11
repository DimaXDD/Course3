using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SumForm
{
    public partial class Form1 : Form
    {
        private readonly HttpClient client;
        public Form1()
        {
            InitializeComponent();
            client = new HttpClient();
            client.BaseAddress = new Uri("http://localhost:5026");
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            try
            {
                int x = int.Parse(textBox1.Text);
                int y = int.Parse(textBox2.Text);

                var content = new StringContent($"X={x}&Y={y}", Encoding.UTF8, 
                    "application/x-www-form-urlencoded");
                var response = await client.PostAsync("/task4", content);

                string result = await response.Content.ReadAsStringAsync();
                textBox3.Text = result;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
