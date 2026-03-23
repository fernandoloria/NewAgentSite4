<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Commission.ascx.cs" Inherits="AgentSite4.Controls.Commission" %>

<style>
  .form-control[readonly] {
    background-color: #ffffff;
  }
</style>

<div class="row page-titles">
  <div class="col-md-12 col-12 align-self-center">
    <h3 class="main-title m-b-0 m-t-0">Agent Commission</h3>
  </div>
</div>

<div class="d-flex flex-column-fluid">
  <div class="container" style="max-width: 100%; padding: initial;">
    <div class="card card-custom gutter-b">
      <form class="form" onsubmit="return false;">
        <div class="card-body">
          <input type="hidden" name="agent" id="agent" value="<%= this.Session["SubAgent"].ToString() %>" />
          <input type="hidden" name="startDate" id="startDate" value="" />
          <input type="hidden" name="endDate" id="endDate" value="" />

          <div class="row">
            <label class="col-form-label col-lg-3 col-sm-12">Choose a Date:</label>
            <div class="form-group col-lg-4 col-md-9 col-sm-12">
              <div class="input-group date">
                <input type="text"
                       class="form-control form-control-sm datepicker"
                       name="txtDate"
                       id="txtDate"
                       placeholder="Select date" />
              </div>
            </div>

            <div class="col-xs-12 col-sm-12 col-lg-5 ml-lg-auto">
              <button type="button"
                      class="btn btn-primary mr-2"
                      name="Submit"
                      onclick="do_commission();">
                Submit
              </button>
            </div>
          </div>

        </div>
      </form>
    </div>
  </div>
</div>

<!-- END REPORT -->

<script>
    function parseMDYToLocalDate(mdy) {
        if (!mdy) return null;
        const [m, d, y] = mdy.split('/').map(x => parseInt(x, 10));
        if (!y || !m || !d) return null;
        const dt = new Date(y, m - 1, d);
        dt.setHours(0, 0, 0, 0);
        return dt;
    }

    function toISODate(d) {
        const y = d.getFullYear();
        const m = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${y}-${m}-${day}`;
    }

    function getWeekBounds(date) {
        const dt = new Date(date.getFullYear(), date.getMonth(), date.getDate());
        dt.setHours(0, 0, 0, 0);

        const dow = dt.getDay(); // 0=Dom,1=Lun,...,6=Sab
        let monday = new Date(dt);
        let sunday = new Date(dt);

        if (dow === 0) {
            monday.setDate(dt.getDate() - 6);
            sunday = dt; // mismo día
        } else {
            monday.setDate(dt.getDate() - (dow - 1));
            sunday.setDate(monday.getDate() + 6);
        }

        return { monday, sunday };
    }

    $("#txtDate").on("changeDate", function () {
        const inputVal = $("#txtDate").val();
        const picked = parseMDYToLocalDate(inputVal);
        if (!picked) return;

        const { monday, sunday } = getWeekBounds(picked);

        $("#startDate").val(toISODate(monday)); // YYYY-MM-DD
        $("#endDate").val(toISODate(sunday));   // YYYY-MM-DD

    });

    function ensureDatesAreFilled() {
        let inputVal = $("#txtDate").val();
        let picked = parseMDYToLocalDate(inputVal);
        if (!picked) {
            picked = new Date();
            picked.setHours(0, 0, 0, 0);
            const mm = String(picked.getMonth() + 1).padStart(2, '0');
            const dd = String(picked.getDate()).padStart(2, '0');
            const yyyy = picked.getFullYear();
            $("#txtDate").val(`${mm}/${dd}/${yyyy}`);
        }

        const { monday, sunday } = getWeekBounds(picked);

        if (!$("#startDate").val()) {
            $("#startDate").val(toISODate(monday));
        }
        if (!$("#endDate").val()) {
            $("#endDate").val(toISODate(sunday));
        }
    }

    function do_commission() {
        ensureDatesAreFilled();

        const d1 = $("#startDate").val(); // YYYY-MM-DD
        const d2 = $("#endDate").val();   // YYYY-MM-DD
        const a = $("#agent").val();

        $("#loading").show();

        $.ajax({
            type: "POST",
            url: "Commission.aspx/CommissionGetTemp",
            data: JSON.stringify({ d1: d1, d2: d2, agent: a }),
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            success: function (result) {
                $("#commission").html(result);
                $("#loading").hide();
            },
            error: function (response) {
                console.log(response);
                $("#loading").hide();
            }
        });
    }
</script>

<hr />
