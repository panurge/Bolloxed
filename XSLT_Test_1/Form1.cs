using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Diagnostics;
using Neo4j.Driver.V1;

namespace XSLT_Test_1
{
    public partial class Form1 : Form
    {
        private static readonly Encoding Utf8Encoder = Encoding.GetEncoding("UTF-8",
                        new EncoderReplacementFallback(string.Empty),
                        new DecoderExceptionFallback());

        
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
        }

        private void button1_Click(object sender, EventArgs e)
        {

            string folderPath = @"E:\xTech\LTFS\ltfs";

            // Create the XslCompiledTransform and load the style sheet.
            XslCompiledTransform xslt = new XslCompiledTransform();
            XslCompiledTransform xsltFilesCsv = new XslCompiledTransform();
            XslCompiledTransform xsltDirectoriesCsv = new XslCompiledTransform();
            XslCompiledTransform xsltRelationshipsCsv = new XslCompiledTransform();
            try
            {
                xsltFilesCsv.Load(@"\\10.176.4.109\nas04\neo4j\import\LtfsToCsvFile.xsl");
                xsltDirectoriesCsv.Load(@"\\10.176.4.109\nas04\neo4j\import\LtfsToCsvDir.xsl");
                xsltRelationshipsCsv.Load(@"\\10.176.4.109\nas04\neo4j\import\LtfsToCsvRel.xsl");
                xslt.Load(@"E:\xTech\LTFS\ltfs\LtfsToCypher.xsl");
            }
            catch (Exception ex)
            {

                Debug.WriteLine(ex.Message);
                throw;
            }

            //// Create the XsltArgumentList.
            //XsltArgumentList argList = new XsltArgumentList();

            //// Calculate the discount date.
            //DateTime orderDate = new DateTime(2004, 01, 15);
            //DateTime discountDate = orderDate.AddDays(20);
            //argList.AddParam("discount", "", discountDate.ToString());

            // Create an XmlWriter to write the output.      
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = false;
            settings.ConformanceLevel = ConformanceLevel.Auto;
            settings.CloseOutput = true;
            settings.Encoding = Encoding.ASCII;

            foreach (string file in Directory.EnumerateFiles(folderPath, "*.schema"))
            {
                //string contents = File.ReadAllText(file);
                //Debug.WriteLine(file.Replace(".schema", "GraphML.xml"));
                if (!File.Exists(file.Replace(".schema", ".Cypher"))) ;// && file.Contains("362")) 
                {
                    Debug.WriteLine("Not exist: " + file.Replace(".schema", ".Cypher"));
                    Debug.WriteLine(@"\\10.176.4.109\nas04\neo4j\import\" + file.Replace(".schema", "Files.csv"));
                    XmlWriter writer = XmlWriter.Create(file.Replace(".schema", ".Cypher"), settings);
                    XmlWriter fcsvwriter = XmlWriter.Create(file.Replace(".schema", "Files.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"\\10.176.4.109\nas04\neo4j\import\"),settings);
                    XmlWriter dcsvwriter = XmlWriter.Create(file.Replace(".schema", "Directories.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"\\10.176.4.109\nas04\neo4j\import\"), settings);
                    XmlWriter rcsvwriter = XmlWriter.Create(file.Replace(".schema", "Relationships.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"\\10.176.4.109\nas04\neo4j\import\"), settings);

                    // Transform the file.
                    //xslt.Transform(new XPathDocument(@"C:\tmp\ltfs\362106.schema"), argList, writer);
                    //try

                        XmlReader xmlReadA = new XmlTextReader(file);
                        XmlReader xmlReadB = new XmlTextReader(file);
                        XmlReader xmlReadC = new XmlTextReader(file);
                        XmlReader xmlReadD = new XmlTextReader(file);

                        //perfom the xslt transformations and write out the transformed files

                        //var utf8Text = Utf8Encoder.GetString(Utf8Encoder.GetBytes(text));

                        // Create Cypher version
                        xslt.Transform(xmlReadA, writer);
                        xmlReadA.Close();
                        writer.Close();

                        // Create Files.csv
                        xsltFilesCsv.Transform(xmlReadB, fcsvwriter);
                        xmlReadB.Close();
                        fcsvwriter.Close();
                        
                        // Create Directories.csv
                        xsltDirectoriesCsv.Transform(xmlReadC, dcsvwriter);
                        xmlReadC.Close();
                        dcsvwriter.Close();
                        
                        // Create Relationships.csv
                        xsltRelationshipsCsv.Transform(xmlReadD, rcsvwriter);
                        xmlReadD.Close();
                        rcsvwriter.Close();

                        string cqlDirectories = @"
                        USING PERIODIC COMMIT
                        LOAD CSV WITH HEADERS
                        FROM '" + file.Replace(".schema", "Directories.csv").Replace(@"E:\xTech\LTFS\ltfs\","file:///") + @"' AS line
                        with line
                        MERGE(d:directory {directory:line.directory, id:line.id})
                        ;";
                        string cqlFiles = @"USING PERIODIC COMMIT
                                                LOAD CSV WITH HEADERS
                                                FROM '" + file.Replace(".schema", "Files.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"file:///") + @"' AS line
                        with line
                        MERGE(d:file {file:line.file, id:line.id})
                        ;";

                        string cqlRelationshipsDirectories = @"USING PERIODIC COMMIT
                                                LOAD CSV WITH HEADERS
                                                FROM '" + file.Replace(".schema", "Relationships.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"file:///") + @"' AS line
                        with line
                        MATCH(d:directory { id:line.ida})
                        MATCH(f:directory {id:line.idb})
                        MERGE(d)-[:CONTAINS]->(f)
                        ;";

                         string cqlRelationshipsFiles = @"USING PERIODIC COMMIT
                                                LOAD CSV WITH HEADERS
                                                FROM '" + file.Replace(".schema", "Relationships.csv").Replace(@"E:\xTech\LTFS\ltfs\", @"file:///") + @"' AS line
                        with line
                        MATCH(d:directory {id:line.ida})
                        MATCH(f:file {id:line.idb})
                        MERGE(d)-[:CONTAINS]->(f)
                        ;";
                        try
                    {

                        //Debug.WriteLine("\r\n\r\n\r\n\r\n");
                        using (var driver = GraphDatabase.Driver("bolt://10.176.4.109", AuthTokens.Basic("neo4j", "avid")))
                        using (var session = driver.Session())
                        {
                            //Debug.WriteLine(cqlDirectories);
                            session.Run(cqlDirectories);
                            //Debug.WriteLine(cqlFiles);
                            session.Run(cqlFiles);
                            //Debug.WriteLine(cqlRelationshipsDirectories);
                            session.Run(cqlRelationshipsDirectories);
                            //Debug.WriteLine(cqlRelationshipsFiles);
                            session.Run(cqlRelationshipsFiles);

                           // int pagenumber = 0;
                           // int pagesize = 30;

                            // List<string> cypher1 = File.ReadLines(file.Replace(".schema", ".Cypher")).Take(3).ToList();
                            // //Debug.WriteLine(String.Concat<String>(cypher1).Replace("CREATE", "\r\nCREATE"));
                            //// session.Run(String.Concat<String>(cypher1).Replace("CREATE", "\r\nCREATE"));

                            // List<string> cypher = File.ReadLines(file.Replace(".schema", ".Cypher")).Skip(1).Take(10).ToList();
                            // while (cypher.Count() > 0)
                            // {
                            //     //foreach (string line in cypher)
                            //     {

                            //         //Debug.WriteLine(String.Concat<String>(cypher).Replace("CREATE","\r\nCREATE"));
                            //       //  session.Run(String.Concat<String>(cypher).Replace("CREATE","\r\nCREATE"));

                            //     }
                            //     cypher.Clear();
                            //     cypher = File.ReadLines(file.Replace(".schema", ".Cypher")).Skip(pagenumber+3).Take(pagesize).ToList();
                            //     pagenumber += pagesize;
                            //     Debug.Write(pagenumber + ", ");
                            //     if((pagenumber % (10*pagesize)) == 0) Debug.WriteLine("");
                            // }
                            // Debug.WriteLine("");
                        }
                    }
                    catch (Exception xe)
                    {
                        Debug.WriteLine(xe.Message);


                    }
                    writer.Close();
                }
            }
                for(int i=0; i< 11; i++)
                {
                    Debug.WriteLine("import-graphml -i /home/avid/3623" + String.Format("{0:00}",i) + "GraphML.xml -t -c -b 5000");
                }

            

        }

        private void button2_Click(object sender, EventArgs e)
        {

            string folderPath = @"C:\Users\news\Downloads\XML-to-Cypher-master\XML-to-Cypher-master\XML\Dracula_ex.xml";

            // Create the XslCompiledTransform and load the style sheet.
            XslCompiledTransform xslt = new XslCompiledTransform();
            try
            {
                xslt.Load(@"C:\Users\news\Downloads\XML-to-Cypher-master\XML-to-Cypher-master\XSLT\k-xslt-for-chapter.xsl");
            }
            catch (Exception ex)
            {

                Debug.WriteLine(ex.Message);
                throw;
            }

            //// Create the XsltArgumentList.
            //XsltArgumentList argList = new XsltArgumentList();

            //// Calculate the discount date.
            //DateTime orderDate = new DateTime(2004, 01, 15);
            //DateTime discountDate = orderDate.AddDays(20);
            //argList.AddParam("discount", "", discountDate.ToString());

            // Create an XmlWriter to write the output.      
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.OmitXmlDeclaration = false;
            settings.ConformanceLevel = ConformanceLevel.Auto;
            settings.CloseOutput = true;
            settings.Encoding = Encoding.ASCII;
            //foreach (string file in Directory.EnumerateFiles(folderPath, "*.schema"))
            //{
            //    //string contents = File.ReadAllText(file);
            //    //Debug.WriteLine(file.Replace(".schema", "GraphML.xml"));
            //    if (!File.Exists(file.Replace(".schema", "GraphML.xml")) && file.Contains("3623"))
                {
                   // Debug.WriteLine("Not exist: " + file.Replace(".schema", "GraphML.xml"));

                    XmlWriter writer = XmlWriter.Create(@"C:\Users\news\Downloads\XML-to-Cypher-master\XML-to-Cypher-master\XML\output.txt", settings);

                    // Transform the file.
                    //xslt.Transform(new XPathDocument(@"C:\tmp\ltfs\362106.schema"), argList, writer);
                    try
                    {
                        XmlReader xmlReadB = new XmlTextReader(folderPath);

                        xslt.Transform(xmlReadB, writer);

                    }
                    catch (Exception xe)
                    {
                        Debug.WriteLine(xe.Message);

                        throw;
                    }
                    writer.Close();
                }
            }
        }
    }

