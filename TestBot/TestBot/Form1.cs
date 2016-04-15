using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using System.IO;
using OpenQA.Selenium.Support.UI;
using System.Data.OleDb;
using System.Threading;
using System.Collections.ObjectModel;

namespace TestBot
{
    public partial class Form1 : Form
    {
        FirefoxDriver fox;

        public Form1()
        {
            
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string pathToCurrentUserProfiles = Environment.ExpandEnvironmentVariables("%APPDATA%") + @"\Mozilla\Firefox\Profiles"; // Path to profile
            string[] pathsToProfiles = Directory.GetDirectories(pathToCurrentUserProfiles, "*.default", SearchOption.TopDirectoryOnly);
            if (pathsToProfiles.Length != 0)
            {
                FirefoxProfile profile = new FirefoxProfile(pathsToProfiles[0]);
                profile.SetPreference("browser.tabs.loadInBackground", false); // set preferences you need
                fox = new FirefoxDriver(new FirefoxBinary(), profile);
            }
            else
            {
                fox = new FirefoxDriver();
            }
            try
            {
                fox.Navigate().GoToUrl("https://acessoseguro.gissonline.com.br/index.cfm?m=portal");
                //fox.FindElementByName("TxtIdent").Clear();
                SendKeys.SendWait("{TAB}");
                fox.FindElementByName("TxtIdent").SendKeys("4244701");
                //fox.FindElementByName("TxtSenha").Clear();
                fox.FindElementByName("TxtSenha").SendKeys("hca2011");
                SendKeys.SendWait("{TAB}");
                SendKeys.SendWait("{TAB}");

                fox.SwitchTo().Frame(0);
                string num1 = fox.FindElementByXPath(@"/html/body/table/tbody/tr/td[1]/img").GetAttribute("value");
                string num2 = fox.FindElementByXPath(@"/html/body/table/tbody/tr/td[2]/img").GetAttribute("value");
                string num3 = fox.FindElementByXPath(@"/html/body/table/tbody/tr/td[3]/img").GetAttribute("value");
                string num4 = fox.FindElementByXPath(@"/html/body/table/tbody/tr/td[4]/img").GetAttribute("value");
                fox.SwitchTo().DefaultContent();
                clickVirtualButton(num1, fox);
                clickVirtualButton(num2, fox);
                clickVirtualButton(num3, fox);
                clickVirtualButton(num4, fox);
                fox.FindElementById("imgLogin").Click();
                //SendKeys.SendWait("{ENTER}");
                Thread.Sleep(5000);
                fox.SwitchTo().Alert().Dismiss();
                fox.SwitchTo().Frame(0);
                fox.FindElement(By.Id("6")).Click();
                fox.SwitchTo().DefaultContent();
                fox.SwitchTo().Frame(2);
                fox.FindElement(By.Name("mes")).SendKeys("04");
                fox.FindElement(By.Name("ano")).SendKeys("2016");
                fox.FindElement(By.LinkText("Notas Recebidas")).Click();
                fox.SwitchTo().DefaultContent();
                fox.SwitchTo().Frame(2);
                new SelectElement(fox.FindElement(By.Name("maxrow"))).SelectByText("500");

                ReadOnlyCollection<IWebElement> element = fox.FindElementsByXPath("//img[contains(@title,'Dados da nota fiscal')]");
                MessageBox.Show(element.Count.ToString());
                element[0].Click();
            }
            catch (Exception err)
            {
                MessageBox.Show(err.Message);
                
            }
            

        }

        private void clickVirtualButton(string num, FirefoxDriver fox) {
            fox.FindElementByXPath("//img[contains(@src,'/images/teclado/tec_" + num + ".gif')]").Click();
            
        }
    }
}
