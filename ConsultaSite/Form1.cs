using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using System.Text.RegularExpressions;
using System.Diagnostics;
using System.Drawing.Imaging;
using System.Threading.Tasks;
using System.IO;
using OpenQA.Selenium.Support.UI;

namespace ConsultaSite
{
    public partial class Form1 : Form
    {

        int i;
        public static string captha="";
        FirefoxDriver fox;

        public Form1()
        {
            InitializeComponent();
            i = 1;
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FirefoxDriver fox = new FirefoxDriver();
            fox.Navigate().GoToUrl("https://www.siscomex.gov.br/vicomex/public/index.jsf");
            fox.Manage().Timeouts().ImplicitlyWait((TimeSpan.FromSeconds(10)));
            //fox.manage().timeouts().pageLoadTimeout(10, TimeUnit.SECONDS);
            fox.FindElement(By.CssSelector("a.logo_certificado")).Click();
            SendKeys.SendWait("{ENTER}"); 

            /*FirefoxDriver fox = new FirefoxDriver();
            fox.Navigate().GoToUrl("https://www.youtube.com");
            fox.FindElementById("masthead-search-term").SendKeys("epic sax");
            SendKeys.SendWait("{ENTER}");
            fox.FindElement(By.LinkText("Epic sax guy 10 hours")).Click();*/
            


        }

        private void solveCaptcha() {

            Ocr ocr = new Ocr();
            FirefoxWebElement image = (FirefoxWebElement)fox.FindElementById("imagemCaptcha");
            Byte[] ba = ((ITakesScreenshot)fox).GetScreenshot().AsByteArray;
            var ss = new Bitmap(new MemoryStream(ba));
            var crop = new Rectangle(image.Location.X, image.Location.Y, image.Size.Width, image.Size.Height);

            //create a new image by cropping the original screenshot
            Bitmap image2 = ss.Clone(crop, ss.PixelFormat);

            using (image2)
            {
                tessnet2.Tesseract tessocr = new tessnet2.Tesseract();
                tessocr.Init(null, "eng", false);
                tessocr.GetThresholdedImage(image2, Rectangle.Empty).Save("c:\\temp\\" + Guid.NewGuid().ToString() + ".jpg");
                // Tessdata directory must be in the directory than this exe
                Console.WriteLine("Multithread version");
                ocr.DoOCRMultiThred(image2, "eng");
                Console.WriteLine("Normal version");
                ocr.DoOCRNormal(image2, "eng");
            }

            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            fox = new FirefoxDriver();
            fox.Navigate().GoToUrl("http://www4.receita.fazenda.gov.br/simulador/");
            solveCaptcha();
            fox.FindElementById("codNCM").SendKeys("40114000");
            fox.FindElementById("valorAduaneiro").SendKeys("1");
            new SelectElement(fox.FindElement(By.Id("select"))).SelectByText("Dólar US");
            fox.FindElement(By.Id("codigoVerificacao")).SendKeys(captha);
            fox.FindElement(By.CssSelector("#form1 > input[name=\"button\"]")).Click();



            while (fox.Url == "http://www4.receita.fazenda.gov.br/simulador/BuscaNCM.jsp")
            {
                solveCaptcha();
                fox.FindElement(By.Id("codigoVerificacao")).SendKeys(captha);
                fox.FindElement(By.CssSelector("#form1 > input[name=\"button\"]")).Click();
            } 

            


        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            webBrowser1.Navigate("http://portal.siscomex.gov.br/");
            System.Threading.Thread.Sleep(200);
           
        }

        private void webBrowser1_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            navigateSuframa();
        }

        private void navigateSuframa()
        {
            if (webBrowser1.ReadyState !=
            WebBrowserReadyState.Complete)
                return; 

            
            
            if (i == 1)
            {
                try
                {
                    HtmlElementCollection name = webBrowser1.Document.GetElementsByTagName("img");
                    
                    name[0].InvokeMember("Click");
                    //SendKeys.SendWait("{TAB}");
                    //SendKeys.SendWait("{ENTER}");
                    System.Threading.Thread.Sleep(200);
                    //SendKeys.SendWait("%{F4}");
                    /*foreach (System.Diagnostics.Process myProc in System.Diagnostics.Process.GetProcesses())
                    {
                        if (myProc.ProcessName == "iexplore")
                        {
                            myProc.Kill();
                        }
                    }
                    //            SendKeys.SendWait("{TAB}");
                    */
                    //HtmlElement test = webBrowser1.Document.GetElementById("tst");
                    System.Threading.Thread.Sleep(2000);
                    SendKeys.Send("{TAB}");
                    System.Threading.Thread.Sleep(2000);
                    SendKeys.Send("{TAB}");
                    System.Threading.Thread.Sleep(200);
                    SendKeys.Send("{TAB}");
                    System.Threading.Thread.Sleep(200);
                    SendKeys.Send("{ENTER}");


                    //el.InvokeMember("Click");





                    //   SendKeys.SendWait("04337168000148");
                    //    SendKeys.SendWait("{TAB}");
                    //   SendKeys.SendWait("Shda2016");
                    //   SendKeys.SendWait("{TAB}");
                    //   SendKeys.SendWait("{ENTER}");

                }
                catch (Exception err)
                {

                    MessageBox.Show(err.Message);
                }
                i = 2;
            }
                    
            
        }

        private void webBrowser1_NewWindow(object sender, CancelEventArgs e)
        {
            webBrowser1.Navigate("https://www.siscomex.gov.br/vicomex/public/index.jsf");
        }

        private Process GetaProcess(string processname)
        {
            Process[] aProc = Process.GetProcessesByName(processname);

            if (aProc.Length > 0)
                return aProc[0];

            else return null;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            

            DialogResult result = openFileDialog1.ShowDialog();
            if (result == DialogResult.OK)
            {
                pictureBox1.Image = new Bitmap(openFileDialog1.FileName);
            }
            
            
        }

        
    }
}
