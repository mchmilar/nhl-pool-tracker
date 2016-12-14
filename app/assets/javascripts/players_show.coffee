$ ->
  Highcharts.chart 'points',
    chart: type: 'column'
    title: text: 'Player Scoring By Round'
    xAxis:
      type: 'category'
      labels:
        rotation: -45
        style:
          fontSize: '13px'
          fontFamily: 'Verdana, sans-serif'
    yAxis:
      min: 0
      title: text: 'Points'
    legend: enabled: false
    tooltip: pointFormat: 'Points: <b>{point.y:.1f}</b>'
    series: [ {
      name: 'Population'
      data: [
        [
            gon.player_class[0][name] 
            gon.player_class[0][pts]
        ]
        [
          'Lagos'
          16.1
        ]
        [
          'Istanbul'
          14.2
        ]
        [
          'Karachi'
          14.0
        ]
        [
          'Mumbai'
          12.5
        ]
        [
          'Moscow'
          12.1
        ]
        [
          'São Paulo'
          11.8
        ]
        [
          'Beijing'
          11.7
        ]
        [
          'Guangzhou'
          11.1
        ]
        [
          'Delhi'
          11.1
        ]
        [
          'Shenzhen'
          10.5
        ]
        [
          'Seoul'
          10.4
        ]
        [
          'Jakarta'
          10.0
        ]
        [
          'Kinshasa'
          9.3
        ]
        [
          'Tianjin'
          9.3
        ]
        [
          'Tokyo'
          9.0
        ]
        [
          'Cairo'
          8.9
        ]
        [
          'Dhaka'
          8.9
        ]
        [
          'Mexico City'
          8.9
        ]
        [
          'Lima'
          8.9
        ]
      ]
      dataLabels:
        enabled: true
        rotation: -90
        color: '#FFFFFF'
        align: 'right'
        format: '{point.y:.1f}'
        y: 10
        style:
          fontSize: '13px'
          fontFamily: 'Verdana, sans-serif'
    } ]
  return
