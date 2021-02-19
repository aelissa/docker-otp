library(readr)
library(sf)
library(opentripplanner)
library(tmap)
library(tidyverse)

otpcon <- otp_connect(hostname =  "otp",
                      router = "north-west",
                      port = 8080)

od <- read_csv("wf01bew_oa.csv")
lcr<-st_read("LCR_OA.gpkg")
oa<-st_read("oa2011.gpkg")


od_lcr<-od[od$`Area of usual residence` %in% lcr$OA11CD,]

lcr_c<-st_centroid(lcr) %>% st_transform(4326) 
lcr_c<-lcr_c%>% 
  mutate(lon=st_coordinates(lcr_c)[,1],
         lat=st_coordinates(lcr_c)[,2])

oa<-st_centroid(oa) %>% st_transform(4326) 
oa<-oa%>% 
  mutate(lon=st_coordinates(oa)[,1],
         lat=st_coordinates(oa)[,2])

#bus time - bike time then weighted average
od_lcr<-od_lcr %>%
  mutate(sameOA=ifelse(`Area of usual residence`==`Area of workplace`,0,1)) %>%
  inner_join(st_drop_geometry(lcr_c[c("OA11CD","lon","lat")]),by=c("Area of usual residence"="OA11CD")) %>%
  rename(lon_r=lon,
         lat_r=lat) %>%
  inner_join(st_drop_geometry(oa[c("OA11CD","lon","lat")]),by=c("Area of workplace"="OA11CD")) %>%
  rename(lon_w=lon,
         lat_w=lat)

m<-od_lcr %>%
  filter(sameOA==1) 

fid<-m$`Area of usual residence`
tid<-m$`Area od workplace`

m<-m %>%
  select(lon_r,lat_r,lon_w,lat_w) %>%
  as.matrix()

d<-as.POSIXct(as.Date(c("2021-02-15 9:25:16 GMT")))

  route<-otp_plan(otpcon = otpcon,
                  fromPlace = m[,1:2],
                  toPlace = m[,3:4],
                  fromID = fid,
                  toID = tid,
                  mode = c("WALK","BUS"),
                  date_time = d,
                  numItineraries=1,
                  ncores = 90
write_rds(routing,"commuting_bus.rds")
