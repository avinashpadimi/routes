Sinatra Application

Start the server:
    cmd: rackup

Running spec:
    cmd: rspec

Seed:
  Shipping / Sailing routes information has to be provided in the json file. (file name should be: responses.json)

Routes:
  This application support 3 routes.

  1.  /cheapest (this end-point will get the cheapest route [direct / indirect] between two ports)
      parameters:
          origin: string
          destination: string
  2.  /cheapest/direct (this end-point will get the cheapest route [only direct] between two ports)
      parameters:
          origin: string
          destination: string
  3.  /fastest (this end-point will get the fastest route [direct / indirect] between two ports)
      parameters:
          origin: string
          destination: string

Note: Documentation is missing 
