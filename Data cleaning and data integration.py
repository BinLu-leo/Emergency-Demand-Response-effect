import pandas as pd
import numpy as np
pd.set_option("display.max_columns",500)

'''
Calculate the electricity consumption for six consecutive days during the EDR trial (1.5 hours)
'''

#import Filter data at a specific time
df_0815_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0815.csv')
df_0815_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0815.csv')
df_0815 = df_0815_.append(df_0815_add)

t1_21_30 = df_0815.query('DATA_TIME == "2019/8/15 21:30:00"')
t1_20_00 = df_0815.query('DATA_TIME == "2019/8/15 20:00:00"')
df_0815_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0815_tmp['0815_elec'] = df_0815_tmp['PAP_R_y'] - df_0815_tmp['PAP_R_x']


df_0816_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0816.csv')
df_0816_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0816.csv')
df_0816 = df_0816_.append(df_0816_add)

t1_21_30 = df_0816.query('DATA_TIME == "2019/8/16 21:30:00"')
t1_20_00 = df_0816.query('DATA_TIME == "2019/8/16 20:00:00"')
df_0816_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0816_tmp['0816_elec'] = df_0816_tmp['PAP_R_y'] - df_0816_tmp['PAP_R_x']

df_0817_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0817.csv')
df_0817_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0817.csv')
df_0817 = df_0817_.append(df_0817_add)

t1_21_30 = df_0817.query('DATA_TIME == "2019/8/17 21:30:00"')
t1_20_00 = df_0817.query('DATA_TIME == "2019/8/17 20:00:00"')
df_0817_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0817_tmp['0817_elec'] = df_0817_tmp['PAP_R_y'] - df_0817_tmp['PAP_R_x']

df_0818_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0818.csv')
df_0818_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0818.csv')
df_0818 = df_0818_.append(df_0818_add)

t1_21_30 = df_0818.query('DATA_TIME == "2019/8/18 21:30:00"')
t1_20_00 = df_0818.query('DATA_TIME == "2019/8/18 20:00:00"')
df_0818_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0818_tmp['0818_elec'] = df_0818_tmp['PAP_R_y'] - df_0818_tmp['PAP_R_x']

df_0819_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0819.csv')
df_0819_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0819.csv')
df_0819 = df_0819_.append(df_0819_add)

t1_21_30 = df_0819.query('DATA_TIME == "2019/8/19 21:30:00"')
t1_20_00 = df_0819.query('DATA_TIME == "2019/8/19 20:00:00"')
df_0819_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0819_tmp['0819_elec'] = df_0819_tmp['PAP_R_y'] - df_0819_tmp['PAP_R_x']

df_0820_ = pd.read_csv('/Users/lubin/Desktop/electricity/data/w1-0820.csv')
df_0820_add = pd.read_csv('/Users/lubin/Desktop/electricity/data/w2-0820.csv')
df_0820 = df_0820_.append(df_0820_add)

t1_21_30 = df_0820.query('DATA_TIME == "2019/8/20 21:30:00"')
t1_20_00 = df_0820.query('DATA_TIME == "2019/8/20 20:00:00"')
df_0820_tmp = pd.merge(t1_20_00, t1_21_30, how='inner', on='CONSNO')
df_0820_tmp['0820_elec'] = df_0820_tmp['PAP_R_y'] - df_0820_tmp['PAP_R_x']

#merge
df_0815_0816 = pd.merge(df_0815_tmp[['CONSNO','0815_elec']], df_0816_tmp[['CONSNO','0816_elec']], how='inner', on='CONSNO')
df_0815_0817 = pd.merge(df_0815_0816, df_0817_tmp[['CONSNO','0817_elec']], how='inner', on='CONSNO')
df_0815_0818 = pd.merge(df_0815_0817, df_0818_tmp[['CONSNO','0818_elec']], how='inner', on='CONSNO')
df_0815_0819 = pd.merge(df_0815_0818, df_0819_tmp[['CONSNO','0819_elec']], how='inner', on='CONSNO')
df_0815_0820 = pd.merge(df_0815_0819, df_0820_tmp[['CONSNO','0820_elec']], how='inner', on='CONSNO')

#Missing and abnormal data
df_0815_0820['att_0819'] = df_0815_0820['att_0819'].fillna(0)
df_0815_0820['sum'] = df_0815_0820.iloc[0::,1:6].apply(lambda x:x.sum(),axis =1)
df_0815_0820 = df_0815_0820.query('sum > 0')

#set time
df_1 = df_0815_0820.rename(columns={'0815_elec':'elec'})
df_1['time'] = 1
df_2 = df_0815_0820.rename(columns={'0816_elec':'elec'})
df_2['time'] = 2
df_3 = df_0815_0820.rename(columns={'0817_elec':'elec'})
df_3['time'] = 3
df_4 = df_0815_0820.rename(columns={'0818_elec':'elec'})
df_4['time'] = 4
df_5 = df_0815_0820.rename(columns={'0819_elec':'elec'})
df_5['time'] = 5
df_6 = df_0815_0820.rename(columns={'0820_elec':'elec'})
df_6['time'] = 6

df1_tmp1 = df_1.append(df_2)
df1_tmp2 = df1_tmp1.append(df_3)
df1_tmp3 = df1_tmp2.append(df_4)
df1_tmp4 = df1_tmp3.append(df_5)
df1_tmp5 = df1_tmp4.append(df_6)
df1_tmp5 = df1_tmp5.sort_values(by=['CONSNO','time'], ascending=True)

#Generate time dummy variable
dummies = df1_tmp5.copy()
dummies['time_'] = dummies['time']
dummies = pd.get_dummies(dummies,columns=['time_'],prefix='time',prefix_sep="_")

#the intersection of treatment variables and time variables
dummies['att1_time1'] = dummies['att_0819']*dummies['time_1']
dummies['att1_time2'] = dummies['att_0819']*dummies['time_2']
dummies['att1_time3'] = dummies['att_0819']*dummies['time_3']
dummies['att1_time4'] = dummies['att_0819']*dummies['time_4']
dummies['att1_time5'] = dummies['att_0819']*dummies['time_5']

dummies.loc[dummies['time'] < 5 ,'time_order'] = 0
dummies.loc[dummies['time'] == 5 ,'time_order'] = 1
dummies.loc[dummies['time'] == 6 ,'time_order'] = 0


'''
Import questionnaire data and other control variables (such as weather data, etc.)
'''

#Import questionnaire data
df_1 = pd.read_excel('/Users/lubin/Desktop/electricity/data/questionnaires.xlsx')
data['children'] = data['children'].replace('..', np.NaN)
data['old'] = data['old'].replace('..', np.NaN)

df_1_1 = df_1.query('Post == 0')
df_1_2 = df_1.query('Post == 1')

#Import weather data
df_2 = pd.read_excel('/Users/lubin/Desktop/electricity/data/weather_data.xlsx')
df_2['datetime'] = df_2['datetime'].apply(pd.to_datetime,format='%H:%M:%S')

df_2_1 = df_2[df_2['datetime'].dt.hour == 20].query('year == 2019 and month == 8 and date == 18") ')
df_2_1 = df_2_1[['wind_direction_2mean_angle','wind_speed_2mean','wind_level','relative_humidity','pressure_hpa','vapor_pressure_hpa','PM2.5']]

df_2_2 = df_2[df_2['datetime'].dt.hour == 20].query('year == 2019 and month == 8 and date == 19") ')
df_2_2 = df_2_2[['wind_direction_2mean_angle','wind_speed_2mean','wind_level','relative_humidity','pressure_hpa','vapor_pressure_hpa','PM2.5']]

df_2 = pd.read_excel('/Users/lubin/Desktop/electricity/data/weather_data.xlsx')
df_2['datetime'] = df_2['datetime'].apply(pd.to_datetime,format='%H:%M:%S')

df_2_1 = df_2[df_2['datetime'].dt.hour == 20].query('year == 2019 and month == 8 and date == 18") ')
df_2_1 = df_2_1[['wind_direction_2mean_angle','wind_speed_2mean','wind_level','relative_humidity','pressure_hpa','vapor_pressure_hpa','PM2.5']]

df_2_2 = df_2[df_2['datetime'].dt.hour == 20].query('year == 2019 and month == 8 and date == 19") ')
df_2_2 = df_2_2[['wind_direction_2mean_angle','wind_speed_2mean','wind_level','relative_humidity','pressure_hpa','vapor_pressure_hpa','PM2.5']]

#merge questionnaire data and weather data
data1 = pd.merge(df_1_1, df_2_1, how='inner', left_on='region', right_on='station')
data2 = pd.merge(df_1_2, df_2_2, how='inner', left_on='region', right_on='station')

data1_2 = data1.append(data2)
data1_2 = data1_2.sort_values(by=['user_id','post'], ascending=True)

'''
Merge all data
'''
data = pd.merge(dummies, data1_2, how='left', left_on='CONSNO', right_on='user_id')


'''
Export
'''
data.to_csv('/Users/lubin/Desktop/electricity/data/EDR_residents_electricity_consumption.csv')


'''
Organize data on the relationship between hourly temperature and hourly electricity consumption
'''
#hourly electricity consumption of six days
name=dict()
name[0] = df_0815.query('DATA_TIME == "2019/8/15"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/15 "+ str(i) + ":00:00\""
    name[i] = df_0815.query(condition)
df_0815_hour = dict()
df_0815_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0815_hour[i] = pd.merge(df_0815_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
df_0816_0 = df_0816.query('DATA_TIME == "2019/8/16"')
df_0815_hour[24] = pd.merge(name[23], df_0816_0, how='inner', on='CONSNO')
df_0815_hour[24]['0815_elec_24'] = df_0815_hour[24]['PAP_R_y'] - df_0815_hour[24]['PAP_R_x']
df_0815_hour[24] = df_0815_hour[24][['CONSNO', 'DATA_TIME_y', '0815_elec_24']]
df_0815_hour[24] = pd.merge(df_0815_hour[22], df_0815_hour[24], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,25):
    tmp = "0815_elec_"+str(i)
    col_name.append(tmp)
df_0815_hour_ = df_0815_hour[24][col_name]

name=dict()
name[0] = df_0816.query('DATA_TIME == "2019/8/16"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/16 "+ str(i) + ":00:00\""
    name[i] = df_0816.query(condition)
merge_name=dict()
for i in range(23):
    col_name = "0816_elec_"+str(i+1)
    merge_name[i+1] = pd.merge(name[i], name[i+1], how='inner', on='CONSNO')
    merge_name[i+1][col_name] = merge_name[i+1]['PAP_R_y'] - merge_name[i+1]['PAP_R_x']
    merge_name[i+1] = merge_name[i+1][['CONSNO', 'DATA_TIME_y', col_name]]
df_0816_hour = dict()
df_0816_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0816_hour[i] = pd.merge(df_0816_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
df_0817_0 = df_0817.query('DATA_TIME == "2019/8/17"')
df_0816_hour[24] = pd.merge(name[23], df_0817_0, how='inner', on='CONSNO')
df_0816_hour[24]['0816_elec_24'] = df_0816_hour[24]['PAP_R_y'] - df_0816_hour[24]['PAP_R_x']
df_0816_hour[24] = df_0816_hour[24][['CONSNO', 'DATA_TIME_y', '0816_elec_24']]
df_0816_hour[24] = pd.merge(df_0816_hour[22], df_0816_hour[24], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,25):
    tmp = "0816_elec_"+str(i)
    col_name.append(tmp)
df_0816_hour_ = df_0816_hour[24][col_name]

name=dict()
name[0] = df_0817.query('DATA_TIME == "2019/8/17"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/17 "+ str(i) + ":00:00\""
    name[i] = df_0817.query(condition)
merge_name=dict()
for i in range(23):
    col_name = "0817_elec_"+str(i+1)
    merge_name[i+1] = pd.merge(name[i], name[i+1], how='inner', on='CONSNO')
    merge_name[i+1][col_name] = merge_name[i+1]['PAP_R_y'] - merge_name[i+1]['PAP_R_x']
    merge_name[i+1] = merge_name[i+1][['CONSNO', 'DATA_TIME_y', col_name]]
df_0817_hour = dict()
df_0817_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0817_hour[i] = pd.merge(df_0817_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
df_0818_0 = df_0818.query('DATA_TIME == "2019/8/18"')
df_0817_hour[24] = pd.merge(name[23], df_0818_0, how='inner', on='CONSNO')
df_0817_hour[24]['0817_elec_24'] = df_0817_hour[24]['PAP_R_y'] - df_0817_hour[24]['PAP_R_x']
df_0817_hour[24] = df_0817_hour[24][['CONSNO', 'DATA_TIME_y', '0817_elec_24']]
df_0817_hour[24] = pd.merge(df_0817_hour[22], df_0817_hour[24], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,25):
    tmp = "0817_elec_"+str(i)
    col_name.append(tmp)
df_0817_hour_ = df_0817_hour[24][col_name]

name=dict()
name[0] = df_0818.query('DATA_TIME == "2019/8/18"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/18 "+ str(i) + ":00:00\""
    name[i] = df_0818.query(condition)
merge_name=dict()
for i in range(23):
    col_name = "0818_elec_"+str(i+1)
    merge_name[i+1] = pd.merge(name[i], name[i+1], how='inner', on='CONSNO')
    merge_name[i+1][col_name] = merge_name[i+1]['PAP_R_y'] - merge_name[i+1]['PAP_R_x']
    merge_name[i+1] = merge_name[i+1][['CONSNO', 'DATA_TIME_y', col_name]]
df_0818_hour = dict()
df_0818_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0818_hour[i] = pd.merge(df_0818_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
df_0819_0 = df_0819.query('DATA_TIME == "2019/8/19"')
df_0818_hour[24] = pd.merge(name[23], df_0819_0, how='inner', on='CONSNO')
df_0818_hour[24]['0818_elec_24'] = df_0818_hour[24]['PAP_R_y'] - df_0818_hour[24]['PAP_R_x']
df_0818_hour[24] = df_0818_hour[24][['CONSNO', 'DATA_TIME_y', '0818_elec_24']]
df_0818_hour[24] = pd.merge(df_0818_hour[22], df_0818_hour[24], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,25):
    tmp = "0818_elec_"+str(i)
    col_name.append(tmp)
df_0818_hour_ = df_0818_hour[24][col_name]

name=dict()
name[0] = df_0819.query('DATA_TIME == "2019/8/19"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/19 "+ str(i) + ":00:00\""
    name[i] = df_0819.query(condition)
merge_name=dict()
for i in range(23):
    col_name = "0819_elec_"+str(i+1)
    merge_name[i+1] = pd.merge(name[i], name[i+1], how='inner', on='CONSNO')
    merge_name[i+1][col_name] = merge_name[i+1]['PAP_R_y'] - merge_name[i+1]['PAP_R_x']
    merge_name[i+1] = merge_name[i+1][['CONSNO', 'DATA_TIME_y', col_name]]
df_0819_hour = dict()
df_0819_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0819_hour[i] = pd.merge(df_0819_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
df_0820_0 = df_0820.query('DATA_TIME == "2019/8/20"')
df_0819_hour[24] = pd.merge(name[23], df_0820_0, how='inner', on='CONSNO')
df_0819_hour[24]['0819_elec_24'] = df_0819_hour[24]['PAP_R_y'] - df_0819_hour[24]['PAP_R_x']
df_0819_hour[24] = df_0819_hour[24][['CONSNO', 'DATA_TIME_y', '0819_elec_24']]
df_0819_hour[24] = pd.merge(df_0819_hour[22], df_0819_hour[24], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,25):
    tmp = "0819_elec_"+str(i)
    col_name.append(tmp)
df_0819_hour_ = df_0819_hour[24][col_name]

name=dict()
name[0] = df_0820.query('DATA_TIME == "2019/8/20"')
for i in range(1,24):
    condition = "DATA_TIME == \"2019/8/20 "+ str(i) + ":00:00\""
    name[i] = df_0820.query(condition)
merge_name=dict()

for i in range(23):
    col_name = "0820_elec_"+str(i+1)
    merge_name[i+1] = pd.merge(name[i], name[i+1], how='inner', on='CONSNO')
    merge_name[i+1][col_name] = merge_name[i+1]['PAP_R_y'] - merge_name[i+1]['PAP_R_x']
    merge_name[i+1] = merge_name[i+1][['CONSNO', 'DATA_TIME_y', col_name]]
df_0820_hour = dict()
df_0820_hour[1] = pd.merge(merge_name[1], merge_name[2], how='inner', on='CONSNO')
for i in range(2,23):
    df_0820_hour[i] = pd.merge(df_0820_hour[i-1], merge_name[i+1], how='inner', on='CONSNO')
col_name = ['CONSNO']
for i in range(1,24):
    tmp = "0820_elec_"+str(i)
    col_name.append(tmp)
df_0820_hour_ = df_0820_hour[22][col_name]

#merge
unique_id_tmp = pd.merge(df_0815_hour_, df_0816_hour_, how='inner', on='CONSNO')
unique_id_tmp = pd.merge(unique_id_tmp, df_0817_hour_, how='inner', on='CONSNO')
unique_id_tmp = pd.merge(unique_id_tmp, df_0818_hour_, how='inner', on='CONSNO')
unique_id_tmp = pd.merge(unique_id_tmp, df_0819_hour_, how='inner', on='CONSNO')
unique_id_tmp = pd.merge(unique_id_tmp, df_0820_hour_, how='inner', on='CONSNO')

unique_id = unique_id_tmp[['CONSNO','0820_elec_1']]
df_0815_hour_uniq = df_0815_hour_[df_0815_hour_.CONSNO.isin(unique_id['CONSNO'])]
df_0816_hour_uniq = df_0816_hour_[df_0816_hour_.CONSNO.isin(unique_id['CONSNO'])]
df_0817_hour_uniq = df_0817_hour_[df_0817_hour_.CONSNO.isin(unique_id['CONSNO'])]
df_0818_hour_uniq = df_0818_hour_[df_0818_hour_.CONSNO.isin(unique_id['CONSNO'])]
df_0819_hour_uniq = df_0819_hour_[df_0819_hour_.CONSNO.isin(unique_id['CONSNO'])]
df_0820_hour_uniq = df_0820_hour_[df_0820_hour_.CONSNO.isin(unique_id['CONSNO'])]

#unique_id
data_unique_id1 = pd.merge(df_0815_hour_uniq, df_0816_hour_uniq, how='inner', on='CONSNO')
data_unique_id2 = pd.merge(data_unique_id1, df_0817_hour_uniq, how='inner', on='CONSNO')
data_unique_id3 = pd.merge(data_unique_id2, df_0818_hour_uniq, how='inner', on='CONSNO')
data_unique_id4 = pd.merge(data_unique_id3, df_0819_hour_uniq, how='inner', on='CONSNO')
data_unique_id = pd.merge(data_unique_id4, df_0820_hour_uniq, how='inner', on='CONSNO')

#hourly electricity consumption of different region
data_0815_city = data_0815.query("region == 'city'")
data_0815_city = data_0815_city.sample(n=3040, replace=False, random_state=None)
data_0815_countytown = data_0815.query("region == 'countytown'")
data_0815_countytown = data_0815_countytown.sample(n=3040, replace=False, random_state=None)
data_0815_town = data_0815.query("region == 'town'")
data_0815_countryside = data_0815.query("region == 'countryside'")
data_0815_countryside = data_0815_countryside.sample(n=3040, replace=False, random_state=None)

data_0815.loc["city_cum"] =data_0815_city.apply(lambda x:x.sum())
data_0815.loc["countytown_sum"] =data_0815_countytown.apply(lambda x:x.sum())
data_0815.loc["town_sum"] =data_0815_town.apply(lambda x:x.sum())
data_0815.loc["countryside_sum"] =data_0815_countryside.apply(lambda x:x.sum())
data_0815.to_csv('/Users/lubin/Desktop/electricity/data/df_0815_hour_uniq_region.csv', encoding='gbk')


data_0816_city = data_0816.query("region == 'city'")
data_0816_city = data_0816_city[data_0816_city.CONSNO.isin(data_0815_city['CONSNO'])]
data_0816_countytown = data_0816.query("region == 'countytown'")
data_0816_countytown = data_0816_countytown[data_0816_countytown.CONSNO.isin(data_0815_countytown['CONSNO'])]
data_0816_town = data_0816.query("region == 'town'")
data_0816_countryside = data_0816.query("region == 'countryside'")
data_0816_countryside = data_0816_countryside[data_0816_countryside.CONSNO.isin(data_0815_countryside['CONSNO'])]

data_0816.loc["city_cum"] =data_0816_city.apply(lambda x:x.sum())
data_0816.loc["countytown_sum"] =data_0816_countytown.apply(lambda x:x.sum())
data_0816.loc["town_sum"] =data_0816_town.apply(lambda x:x.sum())
data_0816.loc["countryside_sum"] =data_0816_countryside.apply(lambda x:x.sum())
data_0816.to_csv('/Users/lubin/Desktop/electricity/data/df_0816_hour_uniq_region.csv', encoding='gbk')

data_0817_city = data_0817.query("region == 'city'")
data_0817_city = data_0817_city[data_0817_city.CONSNO.isin(data_0815_city['CONSNO'])]
data_0817_countytown = data_0817.query("region == 'countytown'")
data_0817_countytown = data_0817_countytown[data_0817_countytown.CONSNO.isin(data_0815_countytown['CONSNO'])]
data_0817_town = data_0817.query("region == 'town'")
data_0817_countryside = data_0817.query("region == 'countryside'")
data_0817_countryside = data_0817_countryside[data_0817_countryside.CONSNO.isin(data_0815_countryside['CONSNO'])]

data_0817.loc["city_cum"] =data_0817_city.apply(lambda x:x.sum())
data_0817.loc["countytown_sum"] =data_0817_countytown.apply(lambda x:x.sum())
data_0817.loc["town_sum"] =data_0817_town.apply(lambda x:x.sum())
data_0817.loc["countryside_sum"] =data_0817_countryside.apply(lambda x:x.sum())
data_0817.to_csv('/Users/lubin/Desktop/electricity/data/df_0818_hour_uniq_region.csv', encoding='gbk')

data_0818_city = data_0818.query("region == 'city'")
data_0818_city = data_0818_city[data_0818_city.CONSNO.isin(data_0815_city['CONSNO'])]
data_0818_countytown = data_0818.query("region == 'countytown'")
data_0818_countytown = data_0818_countytown[data_0818_countytown.CONSNO.isin(data_0815_countytown['CONSNO'])]
data_0818_town = data_0818.query("region == 'town'")
data_0818_countryside = data_0818.query("region == 'countryside'")
data_0818_countryside = data_0818_countryside[data_0818_countryside.CONSNO.isin(data_0815_countryside['CONSNO'])]

data_0818.loc["city_cum"] =data_0818_city.apply(lambda x:x.sum())
data_0818.loc["countytown_sum"] =data_0818_countytown.apply(lambda x:x.sum())
data_0818.loc["town_sum"] =data_0818_town.apply(lambda x:x.sum())
data_0818.loc["countryside_sum"] =data_0818_countryside.apply(lambda x:x.sum())
data_0818.to_csv('/Users/lubin/Desktop/electricity/data/df_0818_hour_uniq_region.csv', encoding='gbk')

data_0819_city = data_0819.query("region == 'city'")
data_0819_city = data_0819_city[data_0819_city.CONSNO.isin(data_0815_city['CONSNO'])]
data_0819_countytown = data_0819.query("region == 'countytown'")
data_0819_countytown = data_0819_countytown[data_0819_countytown.CONSNO.isin(data_0815_countytown['CONSNO'])]
data_0819_town = data_0819.query("region == 'town'")
data_0819_countryside = data_0819.query("region == 'countryside'")
data_0819_countryside = data_0819_countryside[data_0819_countryside.CONSNO.isin(data_0815_countryside['CONSNO'])]

data_0819.loc["city_cum"] =data_0819_city.apply(lambda x:x.sum())
data_0819.loc["countytown_sum"] =data_0819_countytown.apply(lambda x:x.sum())
data_0819.loc["town_sum"] =data_0819_town.apply(lambda x:x.sum())
data_0819.loc["countryside_sum"] =data_0819_countryside.apply(lambda x:x.sum())
data_0819.to_csv('/Users/lubin/Desktop/electricity/data/df_0819_hour_uniq_region.csv', encoding='gbk')

data_0820_city = data_0820.query("region == 'city'")
data_0820_city = data_0820_city[data_0820_city.CONSNO.isin(data_0815_city['CONSNO'])]
data_0820_countytown = data_0820.query("region == 'countytown'")
data_0820_countytown = data_0820_countytown[data_0820_countytown.CONSNO.isin(data_0815_countytown['CONSNO'])]
data_0820_town = data_0820.query("region == 'town'")
data_0820_countryside = data_0820.query("region == 'countryside'")
data_0820_countryside = data_0820_countryside[data_0820_countryside.CONSNO.isin(data_0815_countryside['CONSNO'])]

data_0820.loc["city_cum"] =data_0820_city.apply(lambda x:x.sum())
data_0820.loc["countytown_sum"] =data_0820_countytown.apply(lambda x:x.sum())
data_0820.loc["town_sum"] =data_0820_town.apply(lambda x:x.sum())
data_0820.loc["countryside_sum"] =data_0820_countryside.apply(lambda x:x.sum())
data_0820.to_csv('/Users/lubin/Desktop/electricity/data/df_0820_hour_uniq_region.csv', encoding='gbk')
