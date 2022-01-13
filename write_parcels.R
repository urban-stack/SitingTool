## Create geojson for use in Shiny App

sf_use_s2(FALSE)

parcel_poly <- st_read("data/parcel_data.geojson") %>%
  mutate(log_tot_val = log10(FAIRMARKETTOTAL__asmt)) %>%
  mutate(log_tot_val = ifelse(is.infinite(log_tot_val), 0, log_tot_val)) %>%
  mutate(log_area = log10(LOTAREA__asmt)) %>%
  mutate(log_area = ifelse(is.infinite(log_area), 0, log_area)) %>%
  mutate(vacant = str_detect(USEDESC__asmt, "VACANT")) %>%
  mutate(bldg_pct_val = FAIRMARKETBUILDING__asmt / FAIRMARKETTOTAL__asmt) %>%
  mutate(address = paste(PROPERTYHOUSENUM__asmt, PROPERTYFRACTION__asmt, PROPERTYADDRESS__asmt)) %>% 
  select(PIN, address, log_tot_val, log_area, vacant, bldg_pct_val)

parcel_points <- st_centroid(parcel_poly)

st_write(parcel_poly, "shiny_pitt/parcel_poly.geojson")
st_write(parcel_points, "shiny_pitt/parcel_point.geojson")
