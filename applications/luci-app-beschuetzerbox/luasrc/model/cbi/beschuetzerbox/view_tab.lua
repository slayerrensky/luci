<%header%>  -- default header

<% local ice_cream = luci.model.uci.cursor():get("ice_cream", "tub", "flavor") %>  -- store the ice cream flavors in the ice_cream variable from the config file ice_cream with type tub and list flavor
<% local eating = luci.model.uci.cursor():get("current", "ice", "flavor") %>  -- store the current flavor you are eating in the eating variable from the config file current with type ice and option flavor
<div class="cbi-map" id="cbi-ice_cream">  -- formatting to look like the other pages
<h2><a id="content" name="content">Ice Cream Information</a></h2>
<div class="cbi-map-descr">This is the selected ice cream flavor</div>
<fieldset class="cbi-section" id="cbi-ice_cream-flavor">
        <legend>Ice Cream Flavor</legend>
        <div class="cbi-section-descr"></div>
<ul><li>&nbsp;Flavor <%=eating%></li></ul>  -- use the eating variable to display the current flavor being eaten
</fieldset>
<br></br>
<div class="cbi-map-descr">These are the available flavors at your location</div>
<fieldset class="cbi-section" id="cbi-ice_cream-flavor>
        <legend>Available Ice Cream Flavor</legend>
        <div class="cbi-section-descr"></div>
<ul><li>&nbsp;<%= table.concat(ice_cream, "</li><br /><li>&nbsp;") %></li></ul></fieldset>  -- use the ice_cream available flavors to display them
</div>
<%+footer%>  -- default footer
