using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Profile;
using System.Web.Script.Serialization;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using AgentSite4.ASP;
using AgentSite4.cASEnums;

namespace AgentSite4.Report
{
    public partial class ImportHierarchy : BasePage, IRequiresSessionState
    {
        private const string SessionImportHierarchyId = "ImportHierarchy_Id";
        private const string SessionImportBatchId = "ImportHierarchy_BatchId";
        private const string SessionImportFilterMode = "ImportHierarchy_FilterMode";

        private const string FilterModeDuplicates = "DUPLICATES";
        private const string FilterModeProblems = "PROBLEMS";
        private const string FilterModeAll = "ALL";

        private static readonly string[] RequiredColumns =
        {
            "Agent",
            "Agent_Password",
            "IdPlayer",
            "Player",
            "Player_Password",
            "CreditLimit",
            "MinWager",
            "MaxWager",
            "OnlineMinWager",
            "OnlineMaxWager"
        };

        protected DefaultProfile Profile
        {
            get { return (DefaultProfile)Context.Profile; }
        }

        protected global_asax ApplicationInstance
        {
            get { return (global_asax)Context.ApplicationInstance; }
        }

        private long CurrentImportHierarchyId
        {
            get
            {
                if (Session[SessionImportHierarchyId] == null)
                    return 0;

                return Convert.ToInt64(Session[SessionImportHierarchyId], CultureInfo.InvariantCulture);
            }
        }

        private string CurrentFilterMode
        {
            get
            {
                string value = Convert.ToString(Session[SessionImportFilterMode], CultureInfo.InvariantCulture);

                switch (value)
                {
                    case FilterModeAll:
                    case FilterModeProblems:
                    case FilterModeDuplicates:
                        return value;
                    default:
                        return FilterModeProblems;
                }
            }
            set
            {
                Session[SessionImportFilterMode] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Common.HasRights(ReportPosition.ADDAGENT) ||
                !Common.HasRights(ReportPosition.ADDPLAYER))
            {
                Response.End();
                return;
            }

            lblError.Text = String.Empty;
            lblMessage.Text = String.Empty;

            if (!IsPostBack)
            {
                LoadDistributors();
                LoadTemplateAgents();
                LoadPlayerTemplates();

                if (CurrentImportHierarchyId > 0)
                    ShowBatch(CurrentImportHierarchyId);
            }
        }

        protected void ddlPlayerTemplateAgent_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPlayerTemplates();
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            try
            {
                ValidateUploadSelections();

                List<ImportRow> rows = ReadUploadedFile(fuHierarchy);
                if (rows.Count == 0)
                    throw new ApplicationException("The uploaded file does not contain data rows.");

                long idImportHierarchy;
                Guid importBatchId;

                CreateBatch(
                    Path.GetFileName(fuHierarchy.FileName),
                    Convert.ToInt32(ddlDistributor.SelectedValue, CultureInfo.InvariantCulture),
                    Convert.ToInt32(ddlAgentClone.SelectedValue, CultureInfo.InvariantCulture),
                    Convert.ToInt32(ddlPlayerClone.SelectedValue, CultureInfo.InvariantCulture),
                    chkCloneAgentRights.Checked,
                    out idImportHierarchy,
                    out importBatchId);

                try
                {
                    LoadBatch(idImportHierarchy, rows);
                    ValidateBatch(idImportHierarchy);
                }
                catch
                {
                    DeleteBatch(idImportHierarchy);
                    throw;
                }

                Session[SessionImportHierarchyId] = idImportHierarchy;
                Session[SessionImportBatchId] = importBatchId.ToString();
                CurrentFilterMode = GetInitialFilterMode(idImportHierarchy);

                gvAgents.PageIndex = 0;
                gvPlayers.PageIndex = 0;
                gvAgents.EditIndex = -1;
                gvPlayers.EditIndex = -1;

                ShowBatch(idImportHierarchy);
                lblMessage.Text = "The file was uploaded and validated successfully.";
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnRevalidate_Click(object sender, EventArgs e)
        {
            try
            {
                EnsureCurrentBatch();
                ValidateBatch(CurrentImportHierarchyId);
                AdjustFilterAfterValidation(CurrentImportHierarchyId);
                ResetGridPosition();
                ShowBatch(CurrentImportHierarchyId);
                lblMessage.Text = "The batch was validated successfully.";
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnNewImport_Click(object sender, EventArgs e)
        {
            Session.Remove(SessionImportHierarchyId);
            Session.Remove(SessionImportBatchId);
            Session.Remove(SessionImportFilterMode);

            gvAgents.EditIndex = -1;
            gvPlayers.EditIndex = -1;
            gvAgents.PageIndex = 0;
            gvPlayers.PageIndex = 0;

            pnlUpload.Visible = true;
            pnlResults.Visible = false;
        }

        protected void btnShowDuplicates_Click(object sender, EventArgs e)
        {
            try
            {
                EnsureCurrentBatch();
                CurrentFilterMode = FilterModeDuplicates;
                ResetGridPosition();
                ShowBatch(CurrentImportHierarchyId);
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnShowRowsToFix_Click(object sender, EventArgs e)
        {
            try
            {
                EnsureCurrentBatch();
                CurrentFilterMode = FilterModeProblems;
                ResetGridPosition();
                ShowBatch(CurrentImportHierarchyId);
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnShowAllRows_Click(object sender, EventArgs e)
        {
            try
            {
                EnsureCurrentBatch();
                CurrentFilterMode = FilterModeAll;
                ResetGridPosition();
                ShowBatch(CurrentImportHierarchyId);
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void btnDownloadExample_Click(object sender, EventArgs e)
        {
            StringBuilder csv = new StringBuilder();
            csv.AppendLine(String.Join(",", RequiredColumns));
            csv.AppendLine("EXAMPLEAG,Password123,,EXAMPLE01,Player123,1000,1,100,1,100");

            Response.Clear();
            Response.Buffer = true;
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.UTF8;
            Response.AddHeader(
                "Content-Disposition",
                "attachment; filename=ImportHierarchyExample.csv");
            Response.BinaryWrite(Encoding.UTF8.GetPreamble());
            Response.Write(csv.ToString());
            Response.End();
        }

        protected void gvAgents_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAgents.EditIndex = -1;
            gvAgents.PageIndex = e.NewPageIndex;
            BindAgents(CurrentImportHierarchyId);
        }

        protected void gvAgents_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvAgents.EditIndex = e.NewEditIndex;
            BindAgents(CurrentImportHierarchyId);
        }

        protected void gvAgents_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvAgents.EditIndex = -1;
            BindAgents(CurrentImportHierarchyId);
        }

        protected void gvAgents_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                EnsureCurrentBatch();

                long idImportAgent = Convert.ToInt64(
                    gvAgents.DataKeys[e.RowIndex].Value,
                    CultureInfo.InvariantCulture);

                GridViewRow row = gvAgents.Rows[e.RowIndex];
                string agentAccount = GetTextBoxValue(row, "txtAgentAccount");
                string agentPassword = GetTextBoxValue(row, "txtAgentPassword");

                UpdateAgent(
                    CurrentImportHierarchyId,
                    idImportAgent,
                    agentAccount,
                    agentPassword);

                ValidateBatch(CurrentImportHierarchyId);
                AdjustFilterAfterValidation(CurrentImportHierarchyId);
                gvAgents.EditIndex = -1;
                gvAgents.PageIndex = 0;
                gvPlayers.PageIndex = 0;
                ShowBatch(CurrentImportHierarchyId);
                lblMessage.Text = "The agent was updated and the batch was revalidated.";
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void gvPlayers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPlayers.EditIndex = -1;
            gvPlayers.PageIndex = e.NewPageIndex;
            BindPlayers(CurrentImportHierarchyId);
        }

        protected void gvPlayers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvPlayers.EditIndex = e.NewEditIndex;
            BindPlayers(CurrentImportHierarchyId);
        }

        protected void gvPlayers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvPlayers.EditIndex = -1;
            BindPlayers(CurrentImportHierarchyId);
        }

        protected void gvPlayers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                EnsureCurrentBatch();

                long idImportPlayer = Convert.ToInt64(
                    gvPlayers.DataKeys[e.RowIndex].Value,
                    CultureInfo.InvariantCulture);

                GridViewRow row = gvPlayers.Rows[e.RowIndex];

                UpdatePlayer(
                    CurrentImportHierarchyId,
                    idImportPlayer,
                    GetTextBoxValue(row, "txtPlayerAgentAccount"),
                    GetTextBoxValue(row, "txtPlayerAccount"),
                    GetTextBoxValue(row, "txtPlayerPassword"),
                    ParseNullableDecimal(GetTextBoxValue(row, "txtCreditLimit"), "Credit Limit"),
                    ParseNullableDecimal(GetTextBoxValue(row, "txtMinWager"), "Minimum Wager"),
                    ParseNullableDecimal(GetTextBoxValue(row, "txtMaxWager"), "Maximum Wager"),
                    ParseNullableDecimal(GetTextBoxValue(row, "txtOnlineMinWager"), "Online Minimum Wager"),
                    ParseNullableDecimal(GetTextBoxValue(row, "txtOnlineMaxWager"), "Online Maximum Wager"));

                ValidateBatch(CurrentImportHierarchyId);
                AdjustFilterAfterValidation(CurrentImportHierarchyId);
                gvPlayers.EditIndex = -1;
                gvAgents.PageIndex = 0;
                gvPlayers.PageIndex = 0;
                ShowBatch(CurrentImportHierarchyId);
                lblMessage.Text = "The player was updated and the batch was revalidated.";
            }
            catch (Exception ex)
            {
                lblError.Text = Server.HtmlEncode(ex.Message);
            }
        }

        protected void gvAgents_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            ApplyValidationRowStyle(e.Row);
        }

        protected void gvPlayers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            ApplyValidationRowStyle(e.Row);
        }

        private void ApplyValidationRowStyle(GridViewRow row)
        {
            if (row.RowType != DataControlRowType.DataRow)
                return;

            object value = DataBinder.Eval(row.DataItem, "IsValid");
            if (value == null || value == DBNull.Value)
                return;

            bool isValid = Convert.ToBoolean(value, CultureInfo.InvariantCulture);
            row.CssClass = isValid ? "import-valid" : "import-invalid";
        }

        private void LoadDistributors()
        {
            ddlDistributor.Items.Clear();

            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand("Agent_GetAgentsOrDistributors", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@idAgent", SqlDbType.Int).Value =
                    Convert.ToInt32(Session["SubIdAgent"], CultureInfo.InvariantCulture);
                command.Parameters.Add("@IsDistributor", SqlDbType.Bit).Value = true;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlDistributor.Items.Add(
                            new ListItem(
                                Convert.ToString(reader["AGENT"], CultureInfo.InvariantCulture),
                                Convert.ToString(reader["IdAgent"], CultureInfo.InvariantCulture)));
                    }
                }
            }
        }

        private void LoadTemplateAgents()
        {
            ddlAgentClone.Items.Clear();
            ddlPlayerTemplateAgent.Items.Clear();

            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand("AddOn_GetAgentsByIdAgent", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@idAgent", SqlDbType.Int).Value =
                    Convert.ToInt32(Session["SubIdAgent"], CultureInfo.InvariantCulture);

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string idAgent = Convert.ToString(
                            reader["IdAgent"],
                            CultureInfo.InvariantCulture);
                        string agent = Convert.ToString(
                            reader["AGENT"],
                            CultureInfo.InvariantCulture);

                        ddlAgentClone.Items.Add(new ListItem(agent, idAgent));
                        ddlPlayerTemplateAgent.Items.Add(new ListItem(agent, idAgent));
                    }
                }
            }
        }

        private void LoadPlayerTemplates()
        {
            ddlPlayerClone.Items.Clear();

            if (String.IsNullOrEmpty(ddlPlayerTemplateAgent.SelectedValue))
                return;

            using (SqlConnection connection = CreateDgsDataConnection())
            using (SqlCommand command = new SqlCommand(
                @"SELECT IdPlayer, Player
                  FROM dbo.PLAYER
                  WHERE IdAgent = @IdAgent
                  ORDER BY Player;", connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add("@IdAgent", SqlDbType.Int).Value =
                    Convert.ToInt32(
                        ddlPlayerTemplateAgent.SelectedValue,
                        CultureInfo.InvariantCulture);

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        ddlPlayerClone.Items.Add(
                            new ListItem(
                                Convert.ToString(reader["Player"], CultureInfo.InvariantCulture),
                                Convert.ToString(reader["IdPlayer"], CultureInfo.InvariantCulture)));
                    }
                }
            }
        }

        private void ValidateUploadSelections()
        {
            if (String.IsNullOrEmpty(ddlDistributor.SelectedValue))
                throw new ApplicationException("A parent distributor must be selected.");

            if (String.IsNullOrEmpty(ddlAgentClone.SelectedValue))
                throw new ApplicationException("An agent template must be selected.");

            if (String.IsNullOrEmpty(ddlPlayerClone.SelectedValue))
                throw new ApplicationException("A player template must be selected.");

            if (!fuHierarchy.HasFile)
                throw new ApplicationException("Select an Excel or CSV file.");

            string extension = Path.GetExtension(fuHierarchy.FileName);
            if (!String.Equals(extension, ".xlsx", StringComparison.OrdinalIgnoreCase) &&
                !String.Equals(extension, ".csv", StringComparison.OrdinalIgnoreCase))
            {
                throw new ApplicationException("Only .xlsx and .csv files are supported.");
            }
        }

        private List<ImportRow> ReadUploadedFile(FileUpload upload)
        {
            string extension = Path.GetExtension(upload.FileName);

            if (String.Equals(extension, ".csv", StringComparison.OrdinalIgnoreCase))
                return ReadCsv(upload.PostedFile.InputStream);

            return ReadXlsx(upload.PostedFile.InputStream);
        }

        private List<ImportRow> ReadCsv(Stream input)
        {
            List<ImportRow> result = new List<ImportRow>();

            using (StreamReader reader = new StreamReader(
                input,
                Encoding.UTF8,
                true,
                4096,
                true))
            {
                string headerLine = reader.ReadLine();
                if (headerLine == null)
                    throw new ApplicationException("The CSV file is empty.");

                List<string> headers = ParseCsvLine(headerLine);
                Dictionary<string, int> columns = BuildColumnMap(headers);

                string line;
                int rowNumber = 1;

                while ((line = reader.ReadLine()) != null)
                {
                    rowNumber++;

                    if (String.IsNullOrWhiteSpace(line))
                        continue;

                    List<string> values = ParseCsvLine(line);
                    result.Add(CreateImportRow(rowNumber, columns, values));
                }
            }

            return result;
        }

        private static List<string> ParseCsvLine(string line)
        {
            List<string> values = new List<string>();
            StringBuilder value = new StringBuilder();
            bool insideQuotes = false;

            for (int index = 0; index < line.Length; index++)
            {
                char current = line[index];

                if (current == '"')
                {
                    if (insideQuotes &&
                        index + 1 < line.Length &&
                        line[index + 1] == '"')
                    {
                        value.Append('"');
                        index++;
                    }
                    else
                    {
                        insideQuotes = !insideQuotes;
                    }
                }
                else if (current == ',' && !insideQuotes)
                {
                    values.Add(value.ToString());
                    value.Length = 0;
                }
                else
                {
                    value.Append(current);
                }
            }

            values.Add(value.ToString());
            return values;
        }

        private List<ImportRow> ReadXlsx(Stream input)
        {
            List<ImportRow> result = new List<ImportRow>();

            using (MemoryStream copy = new MemoryStream())
            {
                input.CopyTo(copy);
                copy.Position = 0;

                using (ZipArchive archive = new ZipArchive(
                    copy,
                    ZipArchiveMode.Read,
                    true))
                {
                    List<string> sharedStrings = ReadSharedStrings(archive);
                    string worksheetPath = GetFirstWorksheetPath(archive);
                    ZipArchiveEntry worksheetEntry = archive.GetEntry(worksheetPath);

                    if (worksheetEntry == null)
                        throw new ApplicationException("The first worksheet could not be read.");

                    XDocument worksheet;
                    using (Stream worksheetStream = worksheetEntry.Open())
                    {
                        worksheet = XDocument.Load(worksheetStream);
                    }

                    XNamespace spreadsheet =
                        "http://schemas.openxmlformats.org/spreadsheetml/2006/main";

                    List<XElement> rows = worksheet
                        .Descendants(spreadsheet + "row")
                        .ToList();

                    if (rows.Count == 0)
                        throw new ApplicationException("The Excel worksheet is empty.");

                    List<string> headers = ReadXlsxRow(
                        rows[0],
                        sharedStrings,
                        spreadsheet);

                    Dictionary<string, int> columns = BuildColumnMap(headers);

                    for (int index = 1; index < rows.Count; index++)
                    {
                        List<string> values = ReadXlsxRow(
                            rows[index],
                            sharedStrings,
                            spreadsheet);

                        int rowNumber = GetExcelRowNumber(rows[index], index + 1);

                        if (values.All(String.IsNullOrWhiteSpace))
                            continue;

                        result.Add(CreateImportRow(rowNumber, columns, values));
                    }
                }
            }

            return result;
        }

        private static List<string> ReadSharedStrings(ZipArchive archive)
        {
            List<string> values = new List<string>();
            ZipArchiveEntry entry = archive.GetEntry("xl/sharedStrings.xml");

            if (entry == null)
                return values;

            XDocument document;
            using (Stream stream = entry.Open())
            {
                document = XDocument.Load(stream);
            }

            XNamespace spreadsheet =
                "http://schemas.openxmlformats.org/spreadsheetml/2006/main";

            foreach (XElement item in document.Descendants(spreadsheet + "si"))
            {
                string value = String.Concat(
                    item.Descendants(spreadsheet + "t").Select(t => t.Value));
                values.Add(value);
            }

            return values;
        }

        private static string GetFirstWorksheetPath(ZipArchive archive)
        {
            ZipArchiveEntry workbookEntry = archive.GetEntry("xl/workbook.xml");
            ZipArchiveEntry relationshipsEntry =
                archive.GetEntry("xl/_rels/workbook.xml.rels");

            if (workbookEntry == null || relationshipsEntry == null)
                throw new ApplicationException("The Excel workbook structure is invalid.");

            XDocument workbook;
            XDocument relationships;

            using (Stream stream = workbookEntry.Open())
            {
                workbook = XDocument.Load(stream);
            }

            using (Stream stream = relationshipsEntry.Open())
            {
                relationships = XDocument.Load(stream);
            }

            XNamespace spreadsheet =
                "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
            XNamespace documentRelationships =
                "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
            XNamespace packageRelationships =
                "http://schemas.openxmlformats.org/package/2006/relationships";

            XElement firstSheet = workbook
                .Descendants(spreadsheet + "sheet")
                .FirstOrDefault();

            if (firstSheet == null)
                throw new ApplicationException("The Excel workbook does not contain worksheets.");

            string relationshipId = (string)firstSheet.Attribute(
                documentRelationships + "id");

            XElement relationship = relationships
                .Descendants(packageRelationships + "Relationship")
                .FirstOrDefault(
                    item => String.Equals(
                        (string)item.Attribute("Id"),
                        relationshipId,
                        StringComparison.Ordinal));

            if (relationship == null)
                throw new ApplicationException("The worksheet relationship is invalid.");

            string target = (string)relationship.Attribute("Target");
            if (String.IsNullOrEmpty(target))
                throw new ApplicationException("The worksheet target is invalid.");

            target = target.Replace('\\', '/');
            while (target.StartsWith("../", StringComparison.Ordinal))
                target = target.Substring(3);

            if (target.StartsWith("/", StringComparison.Ordinal))
                target = target.Substring(1);

            if (!target.StartsWith("xl/", StringComparison.OrdinalIgnoreCase))
                target = "xl/" + target;

            return target;
        }

        private static List<string> ReadXlsxRow(
            XElement row,
            IList<string> sharedStrings,
            XNamespace spreadsheet)
        {
            Dictionary<int, string> valuesByColumn = new Dictionary<int, string>();
            int maximumColumn = -1;

            foreach (XElement cell in row.Elements(spreadsheet + "c"))
            {
                string reference = (string)cell.Attribute("r");
                int columnIndex = GetColumnIndex(reference);
                string cellType = (string)cell.Attribute("t");
                string value = String.Empty;

                if (String.Equals(cellType, "inlineStr", StringComparison.Ordinal))
                {
                    value = String.Concat(
                        cell.Descendants(spreadsheet + "t").Select(t => t.Value));
                }
                else
                {
                    XElement valueElement = cell.Element(spreadsheet + "v");
                    string rawValue = valueElement == null
                        ? String.Empty
                        : valueElement.Value;

                    if (String.Equals(cellType, "s", StringComparison.Ordinal))
                    {
                        int sharedIndex;
                        if (Int32.TryParse(
                            rawValue,
                            NumberStyles.Integer,
                            CultureInfo.InvariantCulture,
                            out sharedIndex) &&
                            sharedIndex >= 0 &&
                            sharedIndex < sharedStrings.Count)
                        {
                            value = sharedStrings[sharedIndex];
                        }
                    }
                    else
                    {
                        value = rawValue;
                    }
                }

                valuesByColumn[columnIndex] = value;
                maximumColumn = Math.Max(maximumColumn, columnIndex);
            }

            List<string> values = new List<string>();
            for (int index = 0; index <= maximumColumn; index++)
            {
                string value;
                values.Add(valuesByColumn.TryGetValue(index, out value)
                    ? value
                    : String.Empty);
            }

            return values;
        }

        private static int GetColumnIndex(string cellReference)
        {
            if (String.IsNullOrEmpty(cellReference))
                return 0;

            int column = 0;
            int index = 0;

            while (index < cellReference.Length &&
                   Char.IsLetter(cellReference[index]))
            {
                column = (column * 26) +
                         (Char.ToUpperInvariant(cellReference[index]) - 'A' + 1);
                index++;
            }

            return Math.Max(0, column - 1);
        }

        private static int GetExcelRowNumber(XElement row, int fallback)
        {
            XAttribute attribute = row.Attribute("r");
            int value;

            if (attribute != null &&
                Int32.TryParse(
                    attribute.Value,
                    NumberStyles.Integer,
                    CultureInfo.InvariantCulture,
                    out value))
            {
                return value;
            }

            return fallback;
        }

        private static Dictionary<string, int> BuildColumnMap(
            IList<string> headers)
        {
            Dictionary<string, int> columns =
                new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

            for (int index = 0; index < headers.Count; index++)
            {
                string header = (headers[index] ?? String.Empty).Trim();
                if (header.Length > 0 && !columns.ContainsKey(header))
                    columns.Add(header, index);
            }

            List<string> missing = RequiredColumns
                .Where(column => !columns.ContainsKey(column))
                .ToList();

            if (missing.Count > 0)
            {
                throw new ApplicationException(
                    "The following required columns are missing: " +
                    String.Join(", ", missing.ToArray()) + ".");
            }

            return columns;
        }

        private static ImportRow CreateImportRow(
            int rowNumber,
            IDictionary<string, int> columns,
            IList<string> values)
        {
            ImportRow row = new ImportRow();
            row.RowNumber = rowNumber;
            row.Agent = GetColumnValue(columns, values, "Agent");
            row.AgentPassword = GetColumnValue(columns, values, "Agent_Password");
            row.OriginalIdPlayer = ParseNullableInt(
                GetColumnValue(columns, values, "IdPlayer"));
            row.Player = NormalizeExcelAccount(
                GetColumnValue(columns, values, "Player"));
            row.PlayerPassword = GetColumnValue(
                columns,
                values,
                "Player_Password");
            row.CreditLimit = ParseNullableDecimalValue(
                GetColumnValue(columns, values, "CreditLimit"));
            row.MinWager = ParseNullableDecimalValue(
                GetColumnValue(columns, values, "MinWager"));
            row.MaxWager = ParseNullableDecimalValue(
                GetColumnValue(columns, values, "MaxWager"));
            row.OnlineMinWager = ParseNullableDecimalValue(
                GetColumnValue(columns, values, "OnlineMinWager"));
            row.OnlineMaxWager = ParseNullableDecimalValue(
                GetColumnValue(columns, values, "OnlineMaxWager"));
            return row;
        }

        private static string GetColumnValue(
            IDictionary<string, int> columns,
            IList<string> values,
            string column)
        {
            int index = columns[column];
            if (index < 0 || index >= values.Count)
                return String.Empty;

            return (values[index] ?? String.Empty).Trim();
        }

        private static string NormalizeExcelAccount(string value)
        {
            if (String.IsNullOrWhiteSpace(value))
                return String.Empty;

            decimal numeric;
            if (Decimal.TryParse(
                value,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out numeric) &&
                Decimal.Truncate(numeric) == numeric)
            {
                return numeric.ToString("0", CultureInfo.InvariantCulture);
            }

            return value.Trim();
        }

        private static int? ParseNullableInt(string value)
        {
            if (String.IsNullOrWhiteSpace(value))
                return null;

            int result;
            if (Int32.TryParse(
                value,
                NumberStyles.Integer,
                CultureInfo.InvariantCulture,
                out result))
            {
                return result;
            }

            decimal decimalValue;
            if (Decimal.TryParse(
                value,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out decimalValue) &&
                decimalValue >= Int32.MinValue &&
                decimalValue <= Int32.MaxValue)
            {
                return Decimal.ToInt32(decimalValue);
            }

            return null;
        }

        private static decimal? ParseNullableDecimalValue(string value)
        {
            if (String.IsNullOrWhiteSpace(value))
                return null;

            decimal result;
            if (Decimal.TryParse(
                value,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out result))
            {
                return result;
            }

            if (Decimal.TryParse(
                value,
                NumberStyles.Number,
                CultureInfo.CurrentCulture,
                out result))
            {
                return result;
            }

            return null;
        }

        private void CreateBatch(
            string originalFileName,
            int idDistributor,
            int idAgentClone,
            int idPlayerClone,
            bool cloneAgentRights,
            out long idImportHierarchy,
            out Guid importBatchId)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                "ImportHierarchy_CreateBatch",
                connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 120;

                command.Parameters.Add(
                    "@prmOriginalFileName",
                    SqlDbType.NVarChar,
                    260).Value = originalFileName;
                command.Parameters.Add(
                    "@prmIdDistributor",
                    SqlDbType.Int).Value = idDistributor;
                command.Parameters.Add(
                    "@prmIdAgentClone",
                    SqlDbType.Int).Value = idAgentClone;
                command.Parameters.Add(
                    "@prmIdPlayerClone",
                    SqlDbType.Int).Value = idPlayerClone;
                command.Parameters.Add(
                    "@prmCloneAgentRights",
                    SqlDbType.Bit).Value = cloneAgentRights;
                command.Parameters.Add(
                    "@prmCreatedByIdAgent",
                    SqlDbType.Int).Value =
                    Convert.ToInt32(Session["IdAgent"], CultureInfo.InvariantCulture);
                command.Parameters.Add(
                    "@prmCreatedByAccount",
                    SqlDbType.VarChar,
                    50).Value =
                    Convert.ToString(Session["Agent"], CultureInfo.InvariantCulture);

                SqlParameter outputId = command.Parameters.Add(
                    "@prmOutIdImportHierarchy",
                    SqlDbType.BigInt);
                outputId.Direction = ParameterDirection.Output;

                SqlParameter outputBatchId = command.Parameters.Add(
                    "@prmOutImportBatchId",
                    SqlDbType.UniqueIdentifier);
                outputBatchId.Direction = ParameterDirection.Output;

                connection.Open();
                command.ExecuteNonQuery();

                idImportHierarchy = Convert.ToInt64(
                    outputId.Value,
                    CultureInfo.InvariantCulture);
                importBatchId = (Guid)outputBatchId.Value;
            }
        }

        private void LoadBatch(long idImportHierarchy, IList<ImportRow> rows)
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = Int32.MaxValue;
            serializer.RecursionLimit = 100;
            string json = serializer.Serialize(rows);

            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                "ImportHierarchy_LoadBatch",
                connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.Add(
                    "@prmIdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;
                command.Parameters.Add(
                    "@prmRowsJson",
                    SqlDbType.NVarChar,
                    -1).Value = json;

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        private void ValidateBatch(long idImportHierarchy)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                "ImportHierarchy_ValidateBatch",
                connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 300;
                command.Parameters.Add(
                    "@prmIdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        private void DeleteBatch(long idImportHierarchy)
        {
            try
            {
                using (SqlConnection connection = CreateAddOnsConnection())
                using (SqlCommand command = new SqlCommand(
                    @"DELETE FROM dbo.ImportHierarchyBatch
                      WHERE IdImportHierarchy = @IdImportHierarchy
                        AND Status <> 'IMPORTED';",
                    connection))
                {
                    command.CommandType = CommandType.Text;
                    command.Parameters.Add(
                        "@IdImportHierarchy",
                        SqlDbType.BigInt).Value = idImportHierarchy;

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch
            {
                // Preserve the original upload exception.
            }
        }

        private void ShowBatch(long idImportHierarchy)
        {
            BindSummary(idImportHierarchy);
            BindAgents(idImportHierarchy);
            BindPlayers(idImportHierarchy);
            UpdateFilterInfo(idImportHierarchy);

            pnlUpload.Visible = false;
            pnlResults.Visible = true;
        }

        private void BindSummary(long idImportHierarchy)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                @"SELECT
                      B.ImportBatchId,
                      B.Status,
                      B.TotalAgents,
                      B.InvalidAgents,
                      B.TotalPlayers,
                      B.InvalidPlayers,
                      ISNULL(A.DuplicateAgents, 0) AS DuplicateAgents,
                      ISNULL(P.DuplicatePlayers, 0) AS DuplicatePlayers
                  FROM dbo.ImportHierarchyBatch B
                  OUTER APPLY
                  (
                      SELECT COUNT(*) AS DuplicateAgents
                      FROM dbo.ImportHierarchyAgent IA
                      WHERE IA.IdImportHierarchy = B.IdImportHierarchy
                        AND
                        (
                            IA.ExistsInDatabase = 1
                            OR IA.IsDuplicatedInFile = 1
                        )
                  ) A
                  OUTER APPLY
                  (
                      SELECT COUNT(*) AS DuplicatePlayers
                      FROM dbo.ImportHierarchyPlayer IP
                      WHERE IP.IdImportHierarchy = B.IdImportHierarchy
                        AND
                        (
                            IP.ExistsInDatabase = 1
                            OR IP.IsDuplicatedInFile = 1
                        )
                  ) P
                  WHERE B.IdImportHierarchy = @IdImportHierarchy;",
                connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add(
                    "@IdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                        throw new ApplicationException("The import batch was not found.");

                    lblStatus.Text = Convert.ToString(
                        reader["Status"],
                        CultureInfo.InvariantCulture);
                    lblTotalAgents.Text = Convert.ToString(
                        reader["TotalAgents"],
                        CultureInfo.InvariantCulture);
                    lblInvalidAgents.Text = Convert.ToString(
                        reader["InvalidAgents"],
                        CultureInfo.InvariantCulture);
                    lblDuplicateAgents.Text = Convert.ToString(
                        reader["DuplicateAgents"],
                        CultureInfo.InvariantCulture);
                    lblTotalPlayers.Text = Convert.ToString(
                        reader["TotalPlayers"],
                        CultureInfo.InvariantCulture);
                    lblInvalidPlayers.Text = Convert.ToString(
                        reader["InvalidPlayers"],
                        CultureInfo.InvariantCulture);
                    lblDuplicatePlayers.Text = Convert.ToString(
                        reader["DuplicatePlayers"],
                        CultureInfo.InvariantCulture);
                    lblBatchId.Text = Convert.ToString(
                        reader["ImportBatchId"],
                        CultureInfo.InvariantCulture);
                }
            }
        }

        private void BindAgents(long idImportHierarchy)
        {
            string filterSql = GetFilterSql("IA");
            gvAgents.EmptyDataText = GetEmptyDataText("agents");

            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                @"SELECT
                      IA.IdImportAgent,
                      IA.SourceRowNumber,
                      IA.AgentAccount,
                      IA.AgentPassword,
                      IA.ExistingIdAgent,
                      IA.IsValid,
                      IA.ValidationMessage
                  FROM dbo.ImportHierarchyAgent IA
                  WHERE IA.IdImportHierarchy = @IdImportHierarchy" + filterSql + @"
                  ORDER BY
                      CASE WHEN IA.IsValid = 0 THEN 0 ELSE 1 END,
                      IA.SourceRowNumber;",
                connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add(
                    "@IdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;

                DataTable table = new DataTable();
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    table.Load(reader);
                }

                gvAgents.DataSource = table;
                gvAgents.DataBind();
            }
        }

        private void BindPlayers(long idImportHierarchy)
        {
            string filterSql = GetFilterSql("IP");
            gvPlayers.EmptyDataText = GetEmptyDataText("players");

            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                @"SELECT
                      IP.IdImportPlayer,
                      IP.SourceRowNumber,
                      IP.AgentAccount,
                      IP.PlayerAccount,
                      IP.PlayerPassword,
                      IP.CreditLimit,
                      IP.MinWager,
                      IP.MaxWager,
                      IP.OnlineMinWager,
                      IP.OnlineMaxWager,
                      IP.ExistingIdPlayer,
                      IP.IsValid,
                      IP.ValidationMessage
                  FROM dbo.ImportHierarchyPlayer IP
                  WHERE IP.IdImportHierarchy = @IdImportHierarchy" + filterSql + @"
                  ORDER BY
                      CASE WHEN IP.IsValid = 0 THEN 0 ELSE 1 END,
                      IP.SourceRowNumber;",
                connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add(
                    "@IdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;

                DataTable table = new DataTable();
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    table.Load(reader);
                }

                gvPlayers.DataSource = table;
                gvPlayers.DataBind();
            }
        }

        private string GetFilterSql(string tableAlias)
        {
            switch (CurrentFilterMode)
            {
                case FilterModeAll:
                    return String.Empty;

                case FilterModeDuplicates:
                    return " AND (" + tableAlias + ".ExistsInDatabase = 1 OR " +
                           tableAlias + ".IsDuplicatedInFile = 1)";

                case FilterModeProblems:
                default:
                    return " AND ISNULL(" + tableAlias + ".IsValid, 0) = 0";
            }
        }

        private string GetEmptyDataText(string rowName)
        {
            switch (CurrentFilterMode)
            {
                case FilterModeAll:
                    return "No " + rowName + " were loaded.";

                case FilterModeDuplicates:
                    return "No duplicated " + rowName + " were found.";

                case FilterModeProblems:
                default:
                    return "No " + rowName + " need to be fixed.";
            }
        }

        private void UpdateFilterInfo(long idImportHierarchy)
        {
            ImportProblemCounts counts = GetProblemCounts(idImportHierarchy);

            switch (CurrentFilterMode)
            {
                case FilterModeAll:
                    lblCurrentFilter.Text = "Showing all uploaded rows.";
                    break;

                case FilterModeDuplicates:
                    lblCurrentFilter.Text =
                        "Showing duplicated rows only. Agents: " +
                        counts.DuplicateAgents.ToString(CultureInfo.InvariantCulture) +
                        ", Players: " +
                        counts.DuplicatePlayers.ToString(CultureInfo.InvariantCulture) +
                        ". Edit these rows first; fixed rows disappear from this view after validation.";
                    break;

                case FilterModeProblems:
                default:
                    lblCurrentFilter.Text =
                        "Showing only rows that need to be fixed. Agents: " +
                        counts.InvalidAgents.ToString(CultureInfo.InvariantCulture) +
                        ", Players: " +
                        counts.InvalidPlayers.ToString(CultureInfo.InvariantCulture) +
                        ".";
                    break;
            }

            SetFilterButtonStyles();
        }

        private void SetFilterButtonStyles()
        {
            btnShowDuplicates.CssClass =
                CurrentFilterMode == FilterModeDuplicates
                    ? "btn btn-sm btn-danger"
                    : "btn btn-sm btn-outline-danger";

            btnShowRowsToFix.CssClass =
                CurrentFilterMode == FilterModeProblems
                    ? "btn btn-sm btn-warning ml-2"
                    : "btn btn-sm btn-outline-warning ml-2";

            btnShowAllRows.CssClass =
                CurrentFilterMode == FilterModeAll
                    ? "btn btn-sm btn-secondary ml-2"
                    : "btn btn-sm btn-outline-secondary ml-2";
        }

        private string GetInitialFilterMode(long idImportHierarchy)
        {
            ImportProblemCounts counts = GetProblemCounts(idImportHierarchy);

            if (counts.DuplicateAgents + counts.DuplicatePlayers > 0)
                return FilterModeDuplicates;

            if (counts.InvalidAgents + counts.InvalidPlayers > 0)
                return FilterModeProblems;

            return FilterModeAll;
        }

        private void AdjustFilterAfterValidation(long idImportHierarchy)
        {
            ImportProblemCounts counts = GetProblemCounts(idImportHierarchy);

            if (CurrentFilterMode == FilterModeDuplicates &&
                counts.DuplicateAgents + counts.DuplicatePlayers == 0)
            {
                if (counts.InvalidAgents + counts.InvalidPlayers > 0)
                    CurrentFilterMode = FilterModeProblems;
                else
                    CurrentFilterMode = FilterModeAll;
            }

            if (CurrentFilterMode == FilterModeProblems &&
                counts.InvalidAgents + counts.InvalidPlayers == 0)
            {
                CurrentFilterMode = FilterModeAll;
            }
        }

        private ImportProblemCounts GetProblemCounts(long idImportHierarchy)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                @"SELECT
                      ISNULL(B.InvalidAgents, 0) AS InvalidAgents,
                      ISNULL(B.InvalidPlayers, 0) AS InvalidPlayers,
                      ISNULL(A.DuplicateAgents, 0) AS DuplicateAgents,
                      ISNULL(P.DuplicatePlayers, 0) AS DuplicatePlayers
                  FROM dbo.ImportHierarchyBatch B
                  OUTER APPLY
                  (
                      SELECT COUNT(*) AS DuplicateAgents
                      FROM dbo.ImportHierarchyAgent IA
                      WHERE IA.IdImportHierarchy = B.IdImportHierarchy
                        AND
                        (
                            IA.ExistsInDatabase = 1
                            OR IA.IsDuplicatedInFile = 1
                        )
                  ) A
                  OUTER APPLY
                  (
                      SELECT COUNT(*) AS DuplicatePlayers
                      FROM dbo.ImportHierarchyPlayer IP
                      WHERE IP.IdImportHierarchy = B.IdImportHierarchy
                        AND
                        (
                            IP.ExistsInDatabase = 1
                            OR IP.IsDuplicatedInFile = 1
                        )
                  ) P
                  WHERE B.IdImportHierarchy = @IdImportHierarchy;",
                connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add(
                    "@IdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                        throw new ApplicationException("The import batch was not found.");

                    return new ImportProblemCounts
                    {
                        InvalidAgents = Convert.ToInt32(reader["InvalidAgents"], CultureInfo.InvariantCulture),
                        InvalidPlayers = Convert.ToInt32(reader["InvalidPlayers"], CultureInfo.InvariantCulture),
                        DuplicateAgents = Convert.ToInt32(reader["DuplicateAgents"], CultureInfo.InvariantCulture),
                        DuplicatePlayers = Convert.ToInt32(reader["DuplicatePlayers"], CultureInfo.InvariantCulture)
                    };
                }
            }
        }

        private void ResetGridPosition()
        {
            gvAgents.EditIndex = -1;
            gvPlayers.EditIndex = -1;
            gvAgents.PageIndex = 0;
            gvPlayers.PageIndex = 0;
        }

        private void UpdateAgent(
            long idImportHierarchy,
            long idImportAgent,
            string agentAccount,
            string agentPassword)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            {
                connection.Open();
                SqlTransaction transaction = connection.BeginTransaction();

                try
                {
                    string oldAgentAccount;

                    using (SqlCommand select = new SqlCommand(
                        @"SELECT AgentAccount
                          FROM dbo.ImportHierarchyAgent WITH (UPDLOCK)
                          WHERE IdImportHierarchy = @IdImportHierarchy
                            AND IdImportAgent = @IdImportAgent;",
                        connection,
                        transaction))
                    {
                        select.Parameters.Add(
                            "@IdImportHierarchy",
                            SqlDbType.BigInt).Value = idImportHierarchy;
                        select.Parameters.Add(
                            "@IdImportAgent",
                            SqlDbType.BigInt).Value = idImportAgent;

                        object value = select.ExecuteScalar();
                        if (value == null || value == DBNull.Value)
                            throw new ApplicationException("The agent staging row was not found.");

                        oldAgentAccount = Convert.ToString(
                            value,
                            CultureInfo.InvariantCulture);
                    }

                    using (SqlCommand updateAgent = new SqlCommand(
                        @"UPDATE dbo.ImportHierarchyAgent
                          SET
                              AgentAccount = @AgentAccount,
                              AgentPassword = @AgentPassword,
                              ExistingIdAgent = NULL,
                              IsValid = NULL,
                              ExistsInDatabase = 0,
                              IsDuplicatedInFile = 0,
                              ValidationMessage = NULL,
                              ImportStatus = 'PENDING',
                              ImportMessage = NULL
                          WHERE IdImportHierarchy = @IdImportHierarchy
                            AND IdImportAgent = @IdImportAgent;",
                        connection,
                        transaction))
                    {
                        updateAgent.Parameters.Add(
                            "@AgentAccount",
                            SqlDbType.VarChar,
                            100).Value = agentAccount.Trim();
                        updateAgent.Parameters.Add(
                            "@AgentPassword",
                            SqlDbType.NVarChar,
                            100).Value = ToDatabaseValue(agentPassword);
                        updateAgent.Parameters.Add(
                            "@IdImportHierarchy",
                            SqlDbType.BigInt).Value = idImportHierarchy;
                        updateAgent.Parameters.Add(
                            "@IdImportAgent",
                            SqlDbType.BigInt).Value = idImportAgent;
                        updateAgent.ExecuteNonQuery();
                    }

                    using (SqlCommand updatePlayers = new SqlCommand(
                        @"UPDATE dbo.ImportHierarchyPlayer
                          SET
                              AgentAccount = @NewAgentAccount,
                              AgentPassword = @AgentPassword,
                              IsValid = NULL,
                              ValidationMessage = NULL,
                              ImportStatus = 'PENDING',
                              ImportMessage = NULL
                          WHERE IdImportHierarchy = @IdImportHierarchy
                            AND UPPER(LTRIM(RTRIM(AgentAccount)))
                                COLLATE DATABASE_DEFAULT =
                                UPPER(LTRIM(RTRIM(@OldAgentAccount)))
                                COLLATE DATABASE_DEFAULT;",
                        connection,
                        transaction))
                    {
                        updatePlayers.Parameters.Add(
                            "@NewAgentAccount",
                            SqlDbType.VarChar,
                            100).Value = agentAccount.Trim();
                        updatePlayers.Parameters.Add(
                            "@AgentPassword",
                            SqlDbType.NVarChar,
                            100).Value = ToDatabaseValue(agentPassword);
                        updatePlayers.Parameters.Add(
                            "@OldAgentAccount",
                            SqlDbType.VarChar,
                            100).Value = oldAgentAccount;
                        updatePlayers.Parameters.Add(
                            "@IdImportHierarchy",
                            SqlDbType.BigInt).Value = idImportHierarchy;
                        updatePlayers.ExecuteNonQuery();
                    }

                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

        private void UpdatePlayer(
            long idImportHierarchy,
            long idImportPlayer,
            string agentAccount,
            string playerAccount,
            string playerPassword,
            decimal? creditLimit,
            decimal? minWager,
            decimal? maxWager,
            decimal? onlineMinWager,
            decimal? onlineMaxWager)
        {
            using (SqlConnection connection = CreateAddOnsConnection())
            using (SqlCommand command = new SqlCommand(
                @"UPDATE dbo.ImportHierarchyPlayer
                  SET
                      AgentAccount = @AgentAccount,
                      PlayerAccount = @PlayerAccount,
                      PlayerPassword = @PlayerPassword,
                      CreditLimit = @CreditLimit,
                      MinWager = @MinWager,
                      MaxWager = @MaxWager,
                      OnlineMinWager = @OnlineMinWager,
                      OnlineMaxWager = @OnlineMaxWager,
                      ExistingIdPlayer = NULL,
                      IsValid = NULL,
                      ExistsInDatabase = 0,
                      IsDuplicatedInFile = 0,
                      ValidationMessage = NULL,
                      ImportStatus = 'PENDING',
                      ImportMessage = NULL
                  WHERE IdImportHierarchy = @IdImportHierarchy
                    AND IdImportPlayer = @IdImportPlayer;",
                connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add(
                    "@AgentAccount",
                    SqlDbType.VarChar,
                    100).Value = agentAccount.Trim();
                command.Parameters.Add(
                    "@PlayerAccount",
                    SqlDbType.VarChar,
                    100).Value = playerAccount.Trim();
                command.Parameters.Add(
                    "@PlayerPassword",
                    SqlDbType.NVarChar,
                    100).Value = ToDatabaseValue(playerPassword);
                command.Parameters.Add(
                    "@CreditLimit",
                    SqlDbType.Money).Value = ToDatabaseValue(creditLimit);
                command.Parameters.Add(
                    "@MinWager",
                    SqlDbType.Money).Value = ToDatabaseValue(minWager);
                command.Parameters.Add(
                    "@MaxWager",
                    SqlDbType.Money).Value = ToDatabaseValue(maxWager);
                command.Parameters.Add(
                    "@OnlineMinWager",
                    SqlDbType.Money).Value = ToDatabaseValue(onlineMinWager);
                command.Parameters.Add(
                    "@OnlineMaxWager",
                    SqlDbType.Money).Value = ToDatabaseValue(onlineMaxWager);
                command.Parameters.Add(
                    "@IdImportHierarchy",
                    SqlDbType.BigInt).Value = idImportHierarchy;
                command.Parameters.Add(
                    "@IdImportPlayer",
                    SqlDbType.BigInt).Value = idImportPlayer;

                connection.Open();
                int affected = command.ExecuteNonQuery();
                if (affected != 1)
                    throw new ApplicationException("The player staging row was not found.");
            }
        }

        private static object ToDatabaseValue(object value)
        {
            if (value == null)
                return DBNull.Value;

            string text = value as string;
            if (text != null && String.IsNullOrWhiteSpace(text))
                return DBNull.Value;

            return value;
        }

        private static string GetTextBoxValue(
            GridViewRow row,
            string controlId)
        {
            TextBox textBox = row.FindControl(controlId) as TextBox;
            if (textBox == null)
                throw new ApplicationException(
                    "The field " + controlId + " could not be found.");

            return (textBox.Text ?? String.Empty).Trim();
        }

        private static decimal? ParseNullableDecimal(
            string value,
            string fieldName)
        {
            if (String.IsNullOrWhiteSpace(value))
                return null;

            decimal result;
            if (Decimal.TryParse(
                value,
                NumberStyles.Number,
                CultureInfo.InvariantCulture,
                out result) ||
                Decimal.TryParse(
                    value,
                    NumberStyles.Number,
                    CultureInfo.CurrentCulture,
                    out result))
            {
                return result;
            }

            throw new ApplicationException(
                fieldName + " must be a valid number.");
        }

        private void EnsureCurrentBatch()
        {
            if (CurrentImportHierarchyId <= 0)
                throw new ApplicationException("There is no active import batch.");
        }

        private static SqlConnection CreateAddOnsConnection()
        {
            return new SqlConnection(
                ConfigurationManager
                    .ConnectionStrings["DGS_AddOnsConnectionString"]
                    .ConnectionString);
        }

        private static SqlConnection CreateDgsDataConnection()
        {
            return new SqlConnection(
                ConfigurationManager
                    .ConnectionStrings["DGSDATAConnectionString"]
                    .ConnectionString);
        }

        private sealed class ImportProblemCounts
        {
            public int InvalidAgents { get; set; }
            public int InvalidPlayers { get; set; }
            public int DuplicateAgents { get; set; }
            public int DuplicatePlayers { get; set; }
        }

        [Serializable]
        private sealed class ImportRow
        {
            public int RowNumber { get; set; }
            public string Agent { get; set; }
            public string AgentPassword { get; set; }
            public int? OriginalIdPlayer { get; set; }
            public string Player { get; set; }
            public string PlayerPassword { get; set; }
            public decimal? CreditLimit { get; set; }
            public decimal? MinWager { get; set; }
            public decimal? MaxWager { get; set; }
            public decimal? OnlineMinWager { get; set; }
            public decimal? OnlineMaxWager { get; set; }
        }
    }
}
