import matplotlib.pyplot as plt
import matplotlib.dates as md
import dateutil

datestrings = ['2012-02-21 11:28:17.980000', '2012-02-21 12:15:32.453000', '2012-02-21 23:26:23.734000', '2012-02-26 17:42:15.804000']
dates = [dateutil.parser.parse(s) for s in datestrings]

plt_data = range(5,9)
plt.subplots_adjust(bottom=0.2)
plt.xticks( rotation=25 )

ax=plt.gca()
ax.set_xticks(dates)

xfmt = md.DateFormatter('%Y-%m-%d %H:%M:%S')
#xfmt = md.DateFormatter('%H:%M')
ax.xaxis.set_major_formatter(xfmt)
plt.plot(dates,plt_data, "o-")
plt.show()
