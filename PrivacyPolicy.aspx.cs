using System;
using System.Web.UI;

namespace Expo_Panel
{
    public partial class PrivacyPolicy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // You can dynamically set meta tags here if needed
            }
        }
    }
}