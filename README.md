# High Capacity Color Barcode (HCCB)

This is an Elm library that displays data as an HCCB (High Capacity Color Barcode). It dynamically constructs an SVG element based on the data to display (i.e. on an HTML page).

<div align="center"><img src="https://github.com/canadaduane/elm-hccb/raw/master/docs/hccb-sample.png" width="198" height="210"></div>

## Why?

For the project I'm pursuing, I needed a colorful barcode format that can pack a lot of data. In addition, I hoped to find a barcode that kids would find interesting. When I showed my daughter an HCCB she said "Oh, that one's pretty", so I decided the HCCB fit the bill.

In a future project, I intend to "stream" data through an on-screen HCCB--bypassing tricky usb-serial drivers and other methods of programming an Arduino in the classroom.

## Status

- Data is properly displayed as an HCCB [YES]
- Data is transformed using error-correcting codes [NO]
- Data is read from source as binary [NO]

## About Barcodes

I discovered HCCB, among other formats, through [Specifications For Popular 2D Bar Codes](http://www.adams1.com/stack.html). Skimming through the various formats is quite informative.

## Getting started

You need to have [Elm](http://elm-lang.org/) 0.18 installed on your machine.

Compile the samples in this project with:

    cd examples; make

Then view it:

    elm reactor

## Credit

Authored by Duane Johnson

## License

BSD3 Licensed. Feel free to do what you want with this code; however, HCCB is patented by Microsoft and I have no idea if they want you to use HCCB or not.
