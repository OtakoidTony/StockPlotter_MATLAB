function output = get_finance_datas(code, page)
url = "https://finance.naver.com/item/sise_day.nhn?code="+code+"&page="+page;
header = [matlab.net.http.HeaderField("DNT", "1");
    matlab.net.http.HeaderField("Upgrade-Insecure-Requests", "1");
    matlab.net.http.HeaderField("User-Agent", "Mozilla/5.0");
    matlab.net.http.HeaderField("Sec-Fetch-Site", "none");
    matlab.net.http.HeaderField("Sec-Fetch-Mode", "navigate");
    matlab.net.http.HeaderField("Sec-Fetch-User", "?1");
    matlab.net.http.HeaderField("Sec-Fetch-Dest", "document")]';
method = matlab.net.http.RequestMethod.GET;
request = matlab.net.http.RequestMessage(method,header);
code = send(request, url).Body.Data;
tree = htmlTree(code);
trs = findElement(tree, "tr[onmouseover=""mouseOver(this)""]");
dates = [];
close = [];
diff = [];
open = [];
high = [];
low = [];
volume = [];
for i = 1:size(trs)
    parsed_tr = extractHTMLText(findElement(trs(i), "TD"));
    dates = [dates datetime(parsed_tr(1), 'InputFormat', "yyyy.MM.dd")];
    close = [close str2num(replace(parsed_tr(2), ",", ""))];   % 종가
    diff = [diff str2num(replace(parsed_tr(3), ",", ""))];     % 전일비
    open = [open str2num(replace(parsed_tr(4), ",", ""))];     % 시가
    high = [high str2num(replace(parsed_tr(5), ",", ""))];     % 고가
    low = [low str2num(replace(parsed_tr(6), ",", ""))];       % 저가
    volume = [volume str2num(replace(parsed_tr(7), ",", ""))]; % 거래량
end
output = timetable(dates', close', diff', open', high', low', volume', 'VariableNames', {'close', 'diff', 'open', 'high', 'low', 'volume'});
end
