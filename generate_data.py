import numpy as np, pandas as pd
rng = np.random.default_rng(42)

# ---------- PRODUCTS ----------
cats = {"Electronics":(30,400,.25),"Home & Kitchen":(10,150,.35),"Fashion":(15,120,.45),
        "Beauty":(5,80,.50),"Sports":(10,200,.30),"Books":(5,40,.40)}
prod = []
pid = 1
for c,(lo,hi,m) in cats.items():
    for i in range(1,21):
        price = round(rng.uniform(lo,hi),2)
        prod.append([f"P{pid:04d}",f"{c.split()[0]} Item {i}",c,price,round(price*(1-m*rng.uniform(.8,1.2)),2)])
        pid += 1
products = pd.DataFrame(prod,columns=["product_id","product_name","category","unit_price","unit_cost"])

# ---------- CUSTOMERS ----------
n_c = 5000
countries = ["United States","United Kingdom","Germany","Indonesia","Australia","Canada"]
signup = pd.to_datetime("2024-01-01") + pd.to_timedelta(rng.integers(0,730,n_c),unit="D")
customers = pd.DataFrame({
  "customer_id":[f"C{i:05d}" for i in range(1,n_c+1)],
  "first_name":rng.choice(["Alex","Sam","Jordan","Taylor","Budi","Siti","Maria","Chen","Priya","Liam","Emma","Noah"],n_c),
  "country":rng.choice(countries,n_c,p=[.35,.15,.12,.15,.1,.13]),
  "signup_date":signup.date,
  "acquisition_channel":rng.choice(["Organic","Paid Search","Social Ads","Email","Referral"],n_c,p=[.3,.25,.2,.1,.15]),
  "age":np.clip(rng.normal(35,10,n_c).round(),18,75).astype(int)})
customers["email"] = customers.customer_id.str.lower()+"@example.com"

# ---------- ORDERS ----------
rows=[]; oid=1
end = pd.to_datetime("2025-12-31")
for _,c in customers.iterrows():
    sd = pd.to_datetime(c.signup_date)
    span = (end-sd).days
    if span<=0: continue
    n = rng.poisson(max(span/180,0.3))
    for _ in range(n):
        d = sd + pd.Timedelta(days=int(rng.integers(0,span+1)))
        # seasonality: Nov/Dec boost
        if d.month in (11,12) or rng.random()<.8:
            rows.append([f"O{oid:06d}",c.customer_id,d.date(),
                         rng.choice(["Desktop","Mobile","Tablet"],p=[.4,.5,.1] if d.year==2025 else [.55,.35,.1]),
                         rng.choice(["Card","PayPal","Bank Transfer","COD"],p=[.55,.25,.1,.1])])
            oid+=1
orders = pd.DataFrame(rows,columns=["order_id","customer_id","order_date","device","payment_method"])
orders["order_date"]=pd.to_datetime(orders.order_date)
orders["status"]=rng.choice(["Delivered","Returned","Cancelled"],len(orders),p=[.9,.07,.03])
orders["discount_pct"]=rng.choice([0,0,0,5,10,20],len(orders))
# Hidden story: Black Friday 2025 heavy discounts; Indonesia shipping delays in Q3 2025 -> more cancels
bf = (orders.order_date>="2025-11-24")&(orders.order_date<="2025-11-30")
orders.loc[bf,"discount_pct"]=rng.choice([20,30,40],bf.sum())
orders["shipping_cost"]=np.round(rng.uniform(2,15,len(orders)),2)
orders = orders.merge(customers[["customer_id","country"]],on="customer_id")
q3id = (orders.country=="Indonesia")&(orders.order_date>="2025-07-01")&(orders.order_date<="2025-09-30")
orders.loc[q3id & (rng.random(len(orders))<.25),"status"]="Cancelled"
orders = orders.drop(columns="country")

# ---------- ORDER ITEMS ----------
items=[]
for o in orders.order_id:
    for p in rng.choice(products.product_id,rng.choice([1,2,3,4],p=[.55,.25,.14,.06]),replace=False):
        items.append([o,p,int(rng.choice([1,2,3],p=[.8,.15,.05]))])
order_items = pd.DataFrame(items,columns=["order_id","product_id","quantity"])
order_items.insert(0,"order_item_id",range(1,len(order_items)+1))

# ---------- INJECT DIRTY DATA (for cleaning practice) ----------
customers.loc[rng.choice(n_c,150,replace=False),"country"]=rng.choice(["usa","US","uk","INDONESIA","germany"],150)
customers.loc[rng.choice(n_c,200,replace=False),"email"]=np.nan
customers.loc[rng.choice(n_c,40,replace=False),"age"]=rng.choice([0,-1,150],40)
customers = pd.concat([customers,customers.sample(60,random_state=1)],ignore_index=True)  # duplicates
orders.loc[rng.choice(len(orders),300,replace=False),"shipping_cost"]=np.nan
orders.loc[rng.choice(len(orders),50,replace=False),"discount_pct"]=np.nan
order_items.loc[rng.choice(len(order_items),25,replace=False),"quantity"]=-1
orders["order_date"]=orders.order_date.dt.strftime("%Y-%m-%d")

for n,df in [("customers",customers),("products",products),("orders",orders),("order_items",order_items)]:
    df.to_csv(f"{n}.csv",index=False); print(n,df.shape)
