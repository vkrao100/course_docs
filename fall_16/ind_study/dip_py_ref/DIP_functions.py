from __future__ import division     # enable floatingpoint division
from PIL import Image
import numpy as np                  # case image to array, simple math operations
import matplotlib
import matplotlib.pyplot as plt
from queue import *                 # Add queue support for efficient data transport
from scipy.linalg import block_diag # For creating block diagonal matricies (Hw3)
from scipy.misc import imsave       # for saving images
import os                           # for working with \ finding file directories
import json                         # for reading json data (HW3)
from scipy import fftpack           # Lets not re-invent the wheel.  image FFTs for HW4
import pylab as py
import glob                         # for reading files within a directory
import math
from functools import reduce

## LAST UPDATED: October 17, 2016

##  Homework 1 Functions:

def displayPlot(N, sourceImage,histArray):

    # from https://pythonspot.com/en/matplotlib-bar-chart/
    items = range(N)
    y_pos = np.arange(len(items))

    fig = plt.figure(figsize=(20,10))

    ax1 = fig.add_subplot(121)
    ax1.imshow(sourceImage, cmap="Greys_r")

    ax2 = fig.add_subplot(122)
    ax2.bar(y_pos, histArray, align='center', alpha=0.5)
    ax2.set_ylabel('Relative Frequency')
    ax2.set_xlim(-1, N)
    ax2.set_xlabel('Bin Number')
    ax2.set_title('Histogram')

    plt.tight_layout()

    plt.show()
def getNeighbors(pos, dimension, binaryImage, labelImage):
    # Description:  Given a current starting position (pos), Identify which 4-neighbors of this pixel are
    #               actually (a) inside the image boundaries, and (b) a part of the binary image mask
    #               This will return "actual neighbors" which we want to add to our queue.
    # Input:
    #   pos:              (x,y,) coords of your position around which you want to get neightbors
    #   dimensions:       the dimensions of the source image
    # Returns:
    #   actualNeighbors:  a list of neighbor points surrounding your position which actually live in the image
    #Author:  Jimmy Moore
    # Written:
    # Updated:

    ## Variables

    nx = dimension[0]  # unpack image dimensions -- remember that the max index is nx(ny) - 1!
    ny = dimension[1]

    x = pos[0]  # unpack position dimensions
    y = pos[1]

    north = [x + 1, y]  # Define 4-neighborhood:
    south = [x - 1, y]
    east = [x, y + 1]
    west = [x, y - 1]
    possibleNeighbors = [north, south, east, west]

    actualNeighbors = []  # define empty list

    # Loop over our neighbor candidates
    for i in range(0, len(possibleNeighbors)):
        # Grab i'th pixel
        pix = possibleNeighbors[i]
        px = pix[0]
        py = pix[1]

        # only add pixel to 'actualNeighbors' if it lives within image
        # Remmeber that px, py must be less than nx-1, ny-1 (0-indexing of python)
        if (px >= 0 and py >= 0 and px <= nx - 1 and py <= ny - 1):
            # check that the pixel is in the target selection AND its corresponding labelImage is unwritten
            if (binaryImage[px, py] and labelImage[px, py] == 0):
                actualNeighbors.append([px, py])

    return actualNeighbors
def histogram(inputImage, n, threshLow, threshHigh):
    # Inputs
    #    inputimage:  The input grayscale image to generate a histogram for
    #    n:           Number of bins we want
    #    threshlow:  low threshold value to filter against
    #    threshHigh: High threshold value to filter against
    ########################
    # Varaibles
    ########################
    exp = 8  # bits per channel

    binWidth = np.floor((threshHigh - threshLow + 1) / n)  # Determine bidwidth from intensity range and N
    histArray = np.zeros(n)  # Pre-allocate space for the histogram counter array

    #########################
    # Statements
    #########################

    # check for Errors
    if threshLow == threshHigh:
        print("Error!  Min and max must be different values!")
        return 0

    if threshLow < 0:
        print("Error!  You used a negative value for min.  Clamping min to 0")
        threshLow = 0

    if threshHigh < 0:
        print("Error!  Max should not be negative!  Setting it to full value: 255")
        threshHigh = 2**exp -1

    if binWidth <= 0:
        print("Error!  Max must be greater than min!")
        return 0

    if n > (threshHigh - threshLow+1):
        print("Error! Resolution is too small.  Using unit width between min=" + str(threshLow) + " and max=" + str(
            threshHigh))
        n = threshHigh - threshLow+1
        binWidth = 1

    for l in range(0, n):

        lowIntens = threshLow + l * binWidth

        # make the greatest bin the catch-all to grab any straggling values.
        if (l == n - 1):
            highIntens = threshHigh
        else:
            highIntens = threshLow + (l + 1) * binWidth - 1

        # execute an element-wise comparison over the entire image matrix.
        mask = (inputImage == lowIntens) & (inputImage <= highIntens)
        pixInBin = mask.sum()
        histArray[l] = pixInBin

    #####################
    ## Statements
    ####################

    # collect the total pixels from our min/max range
    totalPix = histArray.sum()

    # normalize histogram to report relative frequency
    if totalPix == 0:
        print("Warning: No pixels in selection")
        return histArray

    return histArray / totalPix  # return relative frequency
def generateConnectedComponent(binaryImage, startLabel):
    # Accepts a binary image as input and assigns sequential label numbers (starting with 'startLabel')
    # to each connected component within the binary image
    # Author: Jimmy Moore
    # Written: Sept 1 2016
    # Revised:

    ## Variables
    imageSize = binaryImage.shape
    nx = imageSize[0]
    ny = imageSize[1]
    labelImage = np.zeros((nx, ny))

    #seed = [0, 0]

    # Loop over every pixel in the image
    for i in range(0, nx - 1):
        for j in range(0, ny - 1):

            seed = [i, j]  # position for this loop

            # if the given pixel is in the mask AND it hasn't been previously written
            if (binaryImage[i, j] and labelImage[i, j] == 0):
                # overwrite labelImage to find the connected component at this pixel
                labelImage = floodFill(binaryImage, seed, startLabel, labelImage)
                startLabel = startLabel + 1

                # print("Coloring component: "+str(startLabel))

    return labelImage
def floodFill(binaryImage, seed, label, labelImage):
    #Author:  Jimmy Moore
    # Written: sept 1, 2016
    # Updated: sept 1,2016
    ## Variables
    imageSize = binaryImage.shape
    nx = imageSize[0]
    ny = imageSize[1]

    x = seed[0]
    y = seed[1]

    ##  Error Checking
    if (x < 0 or x > nx - 1 or y < 0 or y > ny - 1):
        print("Error: Seed pixel is out of bounds of image")
        return

    # test if seed is in the right place
    # print("Value at seed "+str(seed) + ": "+str(binaryImage[x,y]))
    if (not binaryImage[x, y]):
        print("Seed Value is False.  Nothing to do")
        return

    ## Statements
    q = Queue(maxsize=0)  # initialize infinite sized queue
    q.put([x, y])

    count = 1

    while not q.empty():

        # Grab pixel from queue
        px = q.get_nowait()
        tx = px[0]  # test-x
        ty = px[1]  # test-y

        if (binaryImage[tx, ty] and labelImage[tx, ty] == 0):

            labelImage[tx, ty] = label

            # Find all unwritten neighboring pixels
            # getNeighbors(pos,dimension,binaryImage,labelImage):
            pixelNeighbors = getNeighbors(px, imageSize, binaryImage, labelImage)

            # add neighbors to queue
            for i in range(0, len(pixelNeighbors)):
                pixel = pixelNeighbors[i]
                xx = pixel[0]
                yy = pixel[1]

                if (binaryImage[xx, yy] and labelImage[xx, yy] == 0):
                    q.put([xx, yy])

    # print("Finished Component")
    return labelImage
def greatestBorderValue(connectedComponentImage, componentNumber, totalComponents, threshSize):
    # Description:  Determine the most significant bordering component for a given component in a labelImage
    # Input:
    #    connectedComponentImage:  A fully computed connected component image
    #    componentNumber:          a specific component label to evaluate to find its greatest border neighbor
    #    totalComponents:          The total number of components for this specific image
    #    threshSize:               Minimum size of a connected component to count
    # returns:
    #    borderValue:              The label of the most influential bordering component
    # Author:  Jimmy Moore
    # Written: Sept 1 2016
    # Modified: Sept 15 2016

    ## Variables
    imSize = connectedComponentImage.shape
    nx = imSize[0]
    ny = imSize[1]
    componentMask = (connectedComponentImage == componentNumber)
    #print("total components: "+str(totalComponents))
    labelArray = [0] * (totalComponents + 1)

    # generate list of connected component pixels
    cmpXs, cmpYs = np.where(componentMask == True)

    visitedPix = np.zeros((nx, ny))  # Keep track of where we've been...

    ## Statements

    # Loop over all pixels in the the connected component, and consider all their neighbors
    for col, row in zip(cmpXs, cmpYs):  # zip splices X and Y arrays into ordered pairs.

        # check if we've been here before
        if (visitedPix[col, row] == 0):
            # mask it off
            visitedPix[col, row] = 1
            # add its component Label value to our array
            componentNum = int(connectedComponentImage[col, row])
            labelArray[componentNum] += 1

        # if the westward pixel is within the image AND we haven't visited it before
        if (col > 0 and visitedPix[col - 1, row] == 0):
            # mask it off
            visitedPix[col - 1, row] = 1
            # add the image's intensity value to our hist array
            componentNum = int(connectedComponentImage[col - 1, row])
            labelArray[componentNum] += 1

        # check if northward pixel is addressable
        if (row > 0 and visitedPix[col, row - 1] == 0):
            visitedPix[col, row - 1] = 1
            componentNum = int(connectedComponentImage[col, row - 1])
            labelArray[componentNum] += 1

        # check if southward pixel is addressable --subtract 2 to account for loooking ahead one and zero index
        if (row < ny - 2 and visitedPix[col, row + 1] == 0):
            visitedPix[col, row + 1] = 1
            componentNum = int(connectedComponentImage[col, row + 1])
            labelArray[componentNum] += 1

        # check if eastward pixel is addressable --subtract 2 to account for loooking ahead one and zero index
        if (col < nx - 2 and visitedPix[col + 1, row] == 0):
            visitedPix[col + 1, row] = 1
            componentNum = int(connectedComponentImage[col + 1, row])
            labelArray[componentNum] += 1

    # logic from
    # http://stackoverflow.com/questions/16225677/get-the-second-largest-number-in-a-list-in-linear-time

    # after summing all pixels and their neighbors, remove the highest number
    # (we assume that this would be the connected component, might not be correct)
    # histArray.remove(max(histArray))


    # if largest label value = current label, remove and take second.

    # assign the label number (histArray index) associated with the most populated bin.
    # Note:  need to add 2 since we start our label number at 2 and python arrays are zero indexed
    greatestCount = max(labelArray)

    # if our component Label overwhelms our count...
    if (greatestCount == componentNumber):
        # remove it
        labelArray.remove(greatestCount)
        # pick second  greatest
        greatestCount = max(labelArray)

    borderValue = labelArray.index(greatestCount)

    #Now check if this border value is even large enough to be considered a component
    labelMask = connectedComponentImage == borderValue
    numPixels = labelMask.sum()

    # if not, set to zero
    if (numPixels < threshSize):
        borderValue = 0

    return borderValue
def denoise(connectedComponentImage, threshholdSize):
    # Description:  This function removes all connected components smaller that a "threshholdSize' parameter.
    # Inputs:
    #    ConnectedComponentImage:  The component image which is the result of finding all connected components
    #                              from the binary image
    #    startLabel:               the starting label for the individual component masks
    #    endLabel:                 The ending label for the individual component masks
    #    threshholdSize:           Numerical value.  Any component with less than this number of pixels will be
    #                              removed from the image and its label value overwritten with the neighboring
    #                              value of it's most influential neighbor
    # Outputs:
    #    connectedComponentImage: A mask where each component is labeled with a unique label number for every group of
    #                               Connected pixels.
    #
    # Author:  Jimmy Moore
    # Written: Sept 1 2016
    # Modified: Sept 15, 2016

    ## Variables
    imSize = connectedComponentImage.shape
    nx = imSize[0]
    ny = imSize[1]
    denoisedOutput = np.zeros((nx, ny))     # copy input image to output


    #tmp = np.asarray(connectedComponentImage)
    # compute how many components there are

    maxVal = np.amax(connectedComponentImage).astype("int")
    #print("max Val: ")
    #print(maxVal)

    startLabel = 2      # we'll assume this for now
    totalComponents = maxVal+1

    #print("total Components:"+str(totalComponents))

    ## Statements

    # Loop over every component in the image
    for i in range(startLabel, totalComponents):

        # single out the given component
        componentMask = (connectedComponentImage == i)
        componentSize = componentMask.sum()

        #print("Component " + str(i) + ": " + str(componentSize) + " px")

        if (componentSize < threshholdSize):
            #print(" Component "+str(i)+ ": "+str(componentSize)+" px")
            # determine the post influential neighbor
            borderValue = greatestBorderValue(connectedComponentImage, i, totalComponents, threshholdSize)
            #print("    Changed to: "+str(borderValue))
            # print("Too small: ("+str(i)+","+str(componentSize)+")-->"+str(borderValue))
            # assign all pixels in this connected component to some value
            denoisedOutput[connectedComponentImage == i] = borderValue

            temp = denoisedOutput==i
            #print("number of old componentvalues: "+str(temp.sum()))
        else:
            denoisedOutput[connectedComponentImage == i] = i

    return denoisedOutput
def imgThreshold(image, threshLow, threshHigh):
    minMask = image >= threshLow  # everything above
    maxMask = image < threshHigh  # everything below
    mask = np.logical_and(minMask, maxMask)  # union

    return mask.astype("int")  # convert boolean array to 0's and 1's

## Homework 2 Functions:

def falseColorPlots(original, sourceImage, colorTarget, falseColor):
    fig = plt.figure(figsize=(20, 10))

    ax1 = fig.add_subplot(121)
    ax1.imshow(original)

    ax1 = fig.add_subplot(122)
    ax1.imshow(colorTarget)

    fig2 = plt.figure(figsize=(20, 10))

    ax1 = fig2.add_subplot(121)
    ax1.imshow(sourceImage,cmap="Greys_r")

    ax1 = fig2.add_subplot(122)
    ax1.imshow(falseColor)

    plt.tight_layout()

    plt.show()
def plotConnectedComponents(binaryImage, connectedComponent, title, colorMapName):
    # Description: simple function to plot binary threshold image and connected component plot side-by-side.
    #               includes some simple logic to assign random colors to individual components to improve component visibility
    #
    # Inputs:
    #       binaryImage:            any binary threshold image you want to show
    #       connectedComponent:     any connectedcomponent image you want to show (ideally the CC of the binary image)
    #       title:                  text string for the title of the plot
    #       colorMapName:           if you don'e want to use randomized colors, this is where you would specify any one
    #                               of the cmap color profiles
    #
    # Returns:
    #       None
    #
    # Author: Jimmy Moore
    # Written: Sept. 13, 2016
    # Last revised: Sept 13,2016

    ##Variables
    # determine how many colors we need
    numColors = len(np.unique(connectedComponent))  # Needed to add 1 b/c sometimes different labels had same color
    cmap = matplotlib.colors.ListedColormap(
        np.random.rand(numColors, 3))  # idea from: https://gist.github.com/jgomezdans/402500

    fig = plt.figure(title)

    ax1 = fig.add_subplot(121)
    ax1.set_title('Binary Image')
    ax1.imshow(binaryImage, cmap='Greys_r')

    ax2 = fig.add_subplot(122)
    ax2.set_title('Connected Component')

    ax2.imshow(connectedComponent, cmap=cmap)
def compareColorChannelHist(scaledGray, colorChannel, COLOR):

    N = 2**8
    threshLow = 0
    threshHigh = N-1

    print(COLOR)
    # compute histogram of the scaled gray image
    print("Scaled Gray histogram")
    grayHist = histogram(scaledGray, N, threshLow, threshHigh)
    displayPlot(N,scaledGray, grayHist)

    #compute histogram of the colorChannel
    print("original Color Histogram")
    colorHist = histogram(colorChannel,N,threshLow, threshHigh)
    displayPlot(N,colorChannel, colorHist)

def rgbVals(inputImage):
    # rgbVals(inputImage):
    # Description:  This function accepts a color image and returns the extracted R,G,B channel information
    # Input:
    #           inputImage: Color image we wish to decompose into its component R,G,B channels
    # Output:
    #       rchannel:  the pixel intensity values of the red channel
    #       gchannel:  the pixel intensity values of the green channel
    #       bchannel:  the pixel intensity values of the blue channel
    #
    #Author:  Jimmy Moore
    # Written: sept 13, 2016
    # Updated: sept 19,2016

    ## Variables
    rChannel = inputImage[:, :, 0]
    gChannel = inputImage[:, :, 1]
    bChannel = inputImage[:, :, 2]

    return rChannel, gChannel, bChannel
def generateCDF(histogram):
    # generateCDF(histogram)
    # Description:  This function takes an input histogram and computes its scaled CDF for use in transforming the
    #               pixel intensity transformation to be more uniform
    #
    # Inputs:
    #       histogram:  Any input histogram you want to make "uniform"
    #
    # Returns:
    #       CDF:        the look-up table transformation which tells which intensity values to map to others.
    #
    # Author:  Jimmy Moore
    # Written: sept 13, 2016
    # Updated: sept 15,2016

    ## Variables
    histLength = len(histogram)
    CDF = [0] * histLength
    L = 2**8

    # Compute pixel intensity transform function

    for i in range(histLength):
        CDF[i] = (L - 1) * sum(histogram[0:i])

    # round intensity values to integers
    CDF = np.around(CDF).astype("int")

    return CDF
def histEQ(inputImage):
    # Description: This function takes an input image and computes a uniform histogram Mapping to optimize
    #              inputImage contrast
    #
    # Inputs:
    #           inputImage: The target image we want to re-contrast
    # Returns:
    #           correctedImage:     a new grayscale Image with re-mapped intensity values (contrast-adjusted)
    #           equalizedHistogram: The new histogram of this optimized image.
    #
    #Author:  Jimmy Moore
    # Written: sept 13, 2016
    # Updated: sept 19,2016

    ##Variables
    N = 2 ** 8
    threshLow = 0
    threshHigh = N-1
    histArray = histogram(inputImage, N, threshLow, threshHigh)  # Compute histogram for input image
    arrLength = len(histArray)                                   # compute length once (number of bins)
    equalizedHistogram = [0] * arrLength

    #Compute transform
    CDF = generateCDF(histArray)

    # populate new histogram
    for i in range(arrLength):
        #find indicies in LUT where we have mapped bins to the same intensity level
        matchingEntries = (CDF == i)
        #sum all of the corresponding probabilities in the old histArray.
        equalizedHistogram[i] = sum(histArray[matchingEntries])

    # Apply our LUT to the input image to generate the contrast-adjusted output image.
    correctedImage = applyTransform(inputImage, CDF)

    return correctedImage, equalizedHistogram
def createInverseHistogramMap(inputHist, targetHist):
    # def createInverseHistogramMap(inputHist, targetHist):
    # Description:  The 'createInverseHistogramMap' function computes a look-up table for transforming an image with an
    #               'inputHist' intensity profile to look more like 'targetHist'
    # Input:
    #       inputHist:      The histogram of some grayscale image.  This is what we want to transform into targetHist.
    #       targetHist:     The preferred histogram shape/pdf we want to achieve for our inputHist image.
    # Returns:
    #       rtoZ:           This is a manually computed inverse transform, approximating the map which  will transform
    #                       the picture associated with 'inputHist' to resemble the intensity profile described by
    #                       'targetHist'
    #Author:  Jimmy Moore
    # Written: sept 11, 2016
    # Updated: sept 20,2016

    ## Variables

    rCDF = generateCDF(inputHist)       #Compute the CDF's of input and target histograms
    zCDF = generateCDF(targetHist)

    rtoZ = [0]*len(rCDF)                # pre-allocate space for the inverse transform

    # Find the approximate inverse map for transforming inputHist to targetHist
    for i in range(len(rCDF)):
        s = rCDF[i]          # read s value from our LUT
        tmp = abs(zCDF-s)    # subtract from g LUT to find closest element
        rtoZ[i] = tmp.tolist().index(min(tmp))

    return rtoZ
def applyTransform(image, histTransform):
    # applyTransform(image, histTransform)
    # Description:  this function applies the histogram transformation computed by 'createInverseHistogramMap' to
    #               the input image to give it a histogram profile more in line with what was specified by 'targetHist'
    # Inputs:
    #           image:           Any grayscale image we want to transform so its histogram looks more like 'targetHist'
    #           histTransform:   a transform function for re-mapping intensity values
    # Returns:
    #           outputImage:     The new image created by transforming the intensity profile of 'image' to better match
    #                            the 'targetHist' histogram intensity distribution
    # Author:  Jimmy Moore
    # Written: sept 13, 2016
    # modified: Sept 15, 2016

    ##Variables
    imShape= image.shape
    nx = imShape[0]
    ny = imShape[1]
    L = 2**8            # max intensity level

    outputImage = np.zeros((nx,ny))

    #loop over all intensity values and transform/re-map every pixel in the input image
    for i in range(L):
        mask = (image == i)
        outputImage[mask] = histTransform[i]

    return outputImage
def colorize(grayImage, colorImage):
    # def colorize(grayImage, colorImage):
    # Description:  This function takes a grayscale and color image, and  generates a false-color image by creating
    #               three grayscale images resembling the histograms for of the R,G,B color channels of the provided
    #               color image these three grayscale images are composted together to create a false Color version
    #               of the original gray scale image, based on the color profile of the color image.
    # Inputs:
    #       grayImage:  The original grayscaleImage we want to colorize
    #       colorImage: A sample color image used to modify the grayImage histogram to resemble each of its
    #                   R,G,B channels
    # Returns:
    #        rgbArray:  a composited False-color version of grayImage, influenced by the color channel histograms of
    #                   'colorImage
    # Author:  Jimmy Moore
    # Written: sept 13, 2016
    # modified: Sept 15, 2016

    ##Varialbes
    threshLow = 0
    threshHigh = 255
    N = threshHigh - threshLow + 1
    imSize = grayImage.shape
    nx = imSize[0]
    ny = imSize[1]


    ##Statements

    #equalize Gray image
    EQimage, equalizedHistogram = histEQ(grayImage)

    #Extract color-channels from 'colorImage'
    [rChannel, gChannel, bChannel] = rgbVals(colorImage)

    # Compute histograms
    #histArray  = histogram(grayImage, N, threshLow, threshHigh)
    rhistArray = histogram(rChannel,  N, threshLow, threshHigh)
    ghistArray = histogram(gChannel,  N, threshLow, threshHigh)
    bhistArray = histogram(bChannel,  N, threshLow, threshHigh)

    #this is the old way where I was applying the transforms to the stock grayscale image:
            # print("After Equalization: ")
            # displayPlot(N, EQimage, equalizedHistogram)
            #
            # # make original grayscale look like red channel
            # makeRed = createInverseHistogramMap(histArray, rhistArray)
            # routput = applyTransform(grayImage, makeRed)
            #
            # # make original grayscale look like green channel
            # makeGreen = createInverseHistogramMap(histArray, ghistArray)
            # goutput = applyTransform(grayImage, makeGreen)
            #
            # # make original grayscale look like blue channel
            # makeBlue = createInverseHistogramMap(histArray, bhistArray)
            # boutput = applyTransform(grayImage, makeBlue)
            #
            # # build a falseColor Image from the R,G,B outputs
            # rgbArray = np.zeros((nx, ny, 3), 'uint8')
            # rgbArray[..., 0] = routput
            # rgbArray[..., 1] = goutput
            # rgbArray[..., 2] = boutput
            #
            # #img = Image.fromarray(rgbArray)
            # #img.save('myimg.png')
            # # plt.imshow(rgbArray)


    # Instead, I htink I'm supposed to apply all transforms to hte equalized image:

    # make original grayscale look like red channel
    makeRedEQ = createInverseHistogramMap(equalizedHistogram, rhistArray)
    routputEQ = applyTransform(EQimage, makeRedEQ)

    #compareColorChannelHist(routputEQ, rChannel, "RED")

    # make original grayscale look like green channel
    makeGreenEQ = createInverseHistogramMap(equalizedHistogram, ghistArray)
    goutputEQ = applyTransform(EQimage, makeGreenEQ)

    #compareColorChannelHist(goutputEQ, gChannel, "GREEN")

    # make original grayscale look like blue channel
    makeBlueEQ = createInverseHistogramMap(equalizedHistogram, bhistArray)
    boutputEQ = applyTransform(EQimage, makeBlueEQ)

    #compareColorChannelHist(boutputEQ, bChannel, "BLUE")

    # build a falseColor Image from the R,G,B outputs
    rgbArray = np.zeros((nx, ny, 3), 'uint8')
    rgbArray[..., 0] = routputEQ
    rgbArray[..., 1] = goutputEQ
    rgbArray[..., 2] = boutputEQ

    # img = Image.fromarray(rgbArray)
    # img.save('myimg.png')
    # plt.imshow(rgbArray)

    return rgbArray

def otsu(inputImage, bitDepth):
    # Description: This function takes an input image and computes the optimal threshold intensity value vis Otsu's method
    #
    # Inputs:
    #       inputImage:     input grayscale image for thresholding
    #       bitDepth:       bit depth of image
    #
    # Returns:
    #       binaryImage:    a binary image thresholded by the value computed by Otsu's method.
    #
    # Author: Jimmy Moore
    # Written: Sept. 13, 2016
    # Last revised: Sept 22,2016

    ##Varialbes
    L = 2**bitDepth
    intensityList = list(range(L))        # list of intensity values

    threshLow = 0
    threshHigh = L-1
    N = threshHigh - threshLow + 1
    inputHistogram = histogram(inputImage, N, threshLow, threshHigh)

    bins = len(inputHistogram)
    twoClassDifference = [0]*bins       # pre-allocate space for measuring different split points


    ## Old style, not optimized
    for i in range(bins):
        p1 = sum(inputHistogram[0:i])
        p2 = sum(inputHistogram[i: ])

        if (p1 == 0):
            mean1 = 0
            mean2 = 1 / p2 * sum([a * b for a, b in zip(inputHistogram[i:], intensityList[i:])])

        elif (p2 == 0):
            mean1 = 1 / p1 * sum([a * b for a, b in zip(inputHistogram[0:i], intensityList[0:i])])
            mean2 = 0

        else:
            mean1 = 1 / p1 * sum([a * b for a, b in zip(inputHistogram[0:i], intensityList[0:i])])
            mean2 = 1 / p2 * sum([a * b for a, b in zip(inputHistogram[i: ], intensityList[i: ])])

        twoClassDifference[i] = p1 * p2 * (mean1 - mean2) ** 2

    ## trying to use Pre-fix sum fanciness

    # histCumSum = np.cumsum(inputHistogram)
    # iTimesP = [a * b for a, b in zip(intensityList, inputHistogram)]  # Multiply i's and probs together, save as list
    # iTimesPCumSum = np.cumsum(iTimesP)  # compute cumulative sum of imulP list
    # totalITimesPSum = sum(iTimesPCumSum)  # find out what the whole thing sums to
    # for i in range(bins):
    #     p1 = p1 + inputHistogram[i]
    #     p2 = 1.0 - p1
    #     #was trying to take advantage of some prefix sum activity, but it seems like it's not working.
    #
    #     # the remainder of the list is the front sum - total sum
    #     iTimesPSumFromBack = totalITimesPSum - iTimesPSumFromFront
    #
    #     if(i==0):
    #         p1 = inputHistogram[i]
    #         iTimesPSumFromFront = 0
    #     else:
    #         p1 = histCumSum[i-1]
    #         iTimesPSumFromFront = iTimesPCumSum[i-1]
    #
    #
    #     # the sum from the front is just the i'th term of the meanCumSum array
    #     if (p1 == 0):
    #         mean1 = 0.0
    #         mean2 = 1 / p2 * iTimesPSumFromBack
    #
    #     elif (p2 == 0):
    #         mean1 = 1 / p1 * iTimesPSumFromFront
    #         mean2 = 0.0
    #
    #     else:
    #         mean1 = (1 / p1) * iTimesPSumFromFront
    #         mean2 = (1 / p2) * iTimesPSumFromBack
    #     twoClassDifference[i] = p1 * p2 * (mean1 - mean2)**2

    #print(twoClassDifference)
    maxVal = max(twoClassDifference)
    maxIdx = twoClassDifference.index(maxVal)
    print("max Val: "+str(maxVal))
    print("Max Idx: "+str(maxIdx))

    threshLevel = maxIdx-1  # filter just before this
    print("Otsu recommends best split at bin:  "+str(threshLevel))

    #return binary image of pixels less than threshLevel
    binaryOutput = (inputImage >= threshLevel).astype("int")

    return binaryOutput
def adaptiveThresholding(inputImage, blockSize,mvar):
    # Description:
    #
    # Inputs:
    #       inputImage:     input grayscale image for thresholding
    #       blockSize:      size of individual block to parse out and threshold
    #       mvar:           minimum variance required to trigger thresholding
    #
    # Returns:
    #       binaryImage:    a binary image thresholded by the value computed by Otsu's method.
    #
    # Author: Jimmy Moore
    # Written: Sept. 13, 2016
    # Last revised: Sept 13,2016

    ##Variables
    imSize = inputImage.shape
    nx = imSize[0]
    ny = imSize[1]

    #print("image dimensions: "+str(nx)+","+str(ny))

    output = np.zeros((nx,ny))

    xBlocks = int(nx/blockSize)
    yBlocks = int(ny/blockSize)

    for i in range(xBlocks):
        for j in range(yBlocks):

            ## Define positions
            xLeft = i*blockSize
            xRight = (i+1)*blockSize

            yTop = j*blockSize
            yBottom = (j+1)*blockSize

            # Extract image block
            imgBlock = inputImage[xLeft:xRight, yTop:yBottom]

            # compute things
            blockMean = np.mean(imgBlock).astype("int")
            blockVar = np.var(imgBlock)
            blockStdDev = np.sqrt(blockVar)

            #print(imgBlock)
            # print("block (+"+str(i)+","+str(j)+")"+" mean: " +str(blockMean))
            # print("     Var: "+str(blockVar))
            # print("     std: " +str(blockStdDev))

            if(blockVar>mvar):
                threshLevel = np.round(blockMean + blockStdDev).astype("int")
                # print("thresh Level set to: "+str(threshLevel))
                output[xLeft:xRight, yTop:yBottom] = (imgBlock > threshLevel).astype("int")

    return output

## Homework 3 functions

def morph(inputParameters):
    # morph(inputParameters):
    # Description:  This function accepts a textfile which contains two image names/locations (for source and target)
    #               Along with  (x,y) correspondence parameters, and....  The purpose of this function is to
    #               transform the source image into the target image, both geometrically and intensity-wise
    # Input:
    #           inputParameters:a textfile which contains two image names/locations (for source and target)
    #                             Along with  (x,y) correspondence parameters, and....
    # Output:
    #        'N' number of output images showing the source image gradually morphing into the target image.  N is
    #         determined within the inputParameters file.
    #
    # Author:  Jimmy Moore
    # Written: Oct 11, 2016
    # Updated: Oct 19,2016

## Variables

    [xListInput,
     yListInput,
     xListTarget,
     yListTarget,
     sourceFileLocation,
     targetFileLocation,
     outputFileName,
     N,
     kernelType,
     kernelWidth] = readMorphInputs(inputParameters)

    deltaX = xListTarget - xListInput
    deltaY = yListTarget - yListInput

    SourcePic = np.asarray(Image.open(sourceFileLocation))
    TargetPic = np.asarray(Image.open(targetFileLocation))

    print("here")

    print("source location: "+str(sourceFileLocation))
    print(" source picture shape:"+str(SourcePic.shape))

    print("Target location: " + str(targetFileLocation))
    print(" target picture shape:" + str(TargetPic.shape))

    sourceCorners = getImageCorners(SourcePic)
    targetCorners = getImageCorners(TargetPic)

    print("source corners are")
    print(sourceCorners)

    print("target Corners are")
    print(targetCorners)

    ##Statements

    # Create 'B' matrix for the sourcePic transform
    sourceTransformMatrix = buildBMatrix(xListInput, yListInput, kernelType)
    Dsource = block_diag(sourceTransformMatrix, sourceTransformMatrix)

    # Create 'B' matrix for the TargetPic transform
    targetTransformMatrix = buildBMatrix(xListTarget, yListTarget, kernelType)
    Dtarget = block_diag(targetTransformMatrix, targetTransformMatrix)

    print("computing ideal bounding box....")

    [NX,
     NY,
     X_Offset,
     Y_Offset] = getBoundingBox(sourceCorners, targetCorners, N, xListInput,
                                yListInput, deltaX, deltaY, Dsource, Dtarget,
                                xListTarget, yListTarget)

    print("Setting NX = " + str(NX))
    print("Setting NY = " + str(NY))
    print("   ")
    print("Preparing the " + str(N) + " frame output process....")


    for i in range(N+1):   # for every frame we want to compute

        # Set up our canvases
        sourceTransformImage = np.zeros((NY, NX))  # remember rows = NY  and Cols = NX
        targetTransformImage = np.zeros((NY, NX))



        # Construct the righthand side vector
        c = constructRHSVector(xListInput, yListInput, i, N, deltaX, deltaY)

        # Find weighting coefficients for source and target image deformations:
        sourceDeformCoeffs = np.linalg.solve(Dsource, c)
        targetDeformCoeffs = np.linalg.solve(Dtarget, c)

        # Apply these weighting coefficients to source and target pixels to transform the image:
        sourceTransformImage = deformImage(sourceDeformCoeffs, SourcePic, sourceTransformImage,
                                           xListInput, yListInput, X_Offset, Y_Offset)

        targetTransformImage = deformImage(targetDeformCoeffs, TargetPic, targetTransformImage,
                                       xListTarget, yListTarget, X_Offset, Y_Offset)

        # equalize the histograms for these two images:
        EQSourceimage, equalizedHistogram = histEQ(sourceTransformImage)
        EQTargetimage, equalizedHistogram = histEQ(targetTransformImage)


        # this is a nightmare
        #smSTI = smooth(sourceTransformImage)
        #smTTI = smooth(targetTransformImage)



        # blend the two
        alpha = i/N
        #morphImage = (1-alpha)*sourceTransformImage + alpha*targetTransformImage

        # probably want to keep the non-EQ'd image
        morphImage = (1 - alpha) * EQSourceimage + alpha * EQTargetimage
        outputpath = '/MorphOutput/'+outputFileName
        # save pictures
        writeArrayToImg(EQSourceimage, "/MorphOutput/SourceOutput", i)
        writeArrayToImg(EQTargetimage, "/MorphOutput/TargetOutput", i)
        writeArrayToImg(morphImage, outputpath, i)

        print("    ....Frame "+str(i+1)+"/"+str(N)+" saved")

    print("Job Complete!  "+ str(N)+ " frames saved. to MorphOutput/ folder.")
def smooth(picture):

    nx = picture.shape[0]
    ny = picture.shape[1]

    smoothedPic = np.zeros((nx,ny))

    for i in range(1,nx-1):
        for j in range(1,ny-1):

            neighbors = [picture[i,j+1], picture[i-1,j], picture[i,j-1], picture[i+1,j-1],
                         picture[i+1,j]+ picture[i+1,j+1] + picture[i-1,j+1], picture[i-1,j-1] ]

            #smoothedPic[i,j] = mode(neighbors)[0][0]
            #smoothedPic[i,j] = mean(neighbors)
            smoothedPic[i,j] = picture[i,j]

    return smoothedPic
def getBoundingBox(sourceCorners, targetCorners,N, xListInput, yListInput, deltaX, deltaY, Dsource, Dtarget, xListTarget, yListTarget):

    SULUPLLLRXvals = np.zeros((4,N+1))
    SULUPLLLRYvals = np.zeros((4, N+1))
    TULURLLLRXvals = np.zeros((4,N+1))
    TULURLLLRYvals = np.zeros((4, N+1))

    for i in range(len(sourceCorners)):

        sourcePoint = [sourceCorners[i][0], sourceCorners[i][1]]  # (x,y) coords need to be saved as (cols, rows)
        targetPoint = [targetCorners[i][0], targetCorners[i][1]]


        for j in range(N+1):

            # Construct the righthand side vector
            c = constructRHSVector(xListInput, yListInput, j, N, deltaX, deltaY)

            # Find weighting coefficients for source and target image deformations:
            sourceDeformCoeffs = np.linalg.solve(Dsource, c)
            targetDeformCoeffs = np.linalg.solve(Dtarget, c)

            newSourcePoint = applyPointTransform(xListInput, yListInput, sourceDeformCoeffs, sourcePoint)
            newTargetPoint = applyPointTransform(xListTarget, yListTarget, targetDeformCoeffs, targetPoint)

            SULUPLLLRXvals[i,j] = newSourcePoint[0]
            SULUPLLLRYvals[i, j] = newSourcePoint[1]

            TULURLLLRXvals[i,j] = newTargetPoint[0]
            TULURLLLRYvals[i, j] = newTargetPoint[1]

    # print("Sx")
    # print(SULUPLLLRXvals)
    # print("sy")
    # print(SULUPLLLRYvals)
    # print("Tx")
    # print(TULURLLLRXvals)
    # print("Ty")
    # print(TULURLLLRYvals)
    #

    minSourceXVal = np.matrix.min(np.asmatrix(SULUPLLLRXvals))
    minSourceYVal = np.matrix.min(np.asmatrix(SULUPLLLRYvals))

    maxSourceXVal = np.matrix.max(np.asmatrix(SULUPLLLRXvals))
    maxSourceYVal = np.matrix.max(np.asmatrix(SULUPLLLRYvals))

    minTargetXVal =  np.matrix.min(np.asmatrix(TULURLLLRXvals))
    minTargetYVal =  np.matrix.min(np.asmatrix(TULURLLLRYvals))

    maxTargetXVal = np.matrix.max(np.asmatrix(TULURLLLRXvals))
    maxTargetYVal = np.matrix.max(np.asmatrix(TULURLLLRYvals))

    #of all the translated corner values, find the abs() of the smallest one.  If negative, this will be our
    # offset
    minestX = abs(min(minSourceXVal, minTargetXVal)).astype("int") +20
    minestY = abs(min(minSourceYVal, minTargetYVal)).astype("int")+20

    # of all the translated corner values (for source and target), find the largest value.  this will adjust our bounding
    # box
    maxestX = max(maxSourceXVal, maxTargetXVal).astype("int")
    maxestY = max(maxSourceYVal, maxTargetYVal).astype("int")

    print("smallest x in translation: "+str(minestX))
    print("smallest y in translation: " + str(minestY))

    print("largest x in translation: " + str(maxestX))
    print("largest y in translation: " + str(maxestY))

    NX = maxestX + minestX+50
    NY = maxestY + minestY+50

    return NX,NY, minestX, minestY
def getImageCorners(picture):
    UL = [0,picture.shape[0]]
    UR = [picture.shape[1], picture.shape[0]]
    LL = [0,0]
    LR = [picture.shape[1],0]

    return [UL, UR, LL, LR]
def writeArrayToImg(img,FILENAME,FRAME_NUM):
    cwd = os.getcwd()
    path = cwd+FILENAME
    imsave(path+'_{}.png'.format(FRAME_NUM), img)

def deformImage(weightingVector, picture, canvas,xList, yList,X_OFFSET, Y_OFFSET):

    for i in range(picture.shape[0]):        #loop over the Y values in pic (rows)
        for j in range(picture.shape[1]):   # Loop over the X values (cols)

            point = [j,i]       # (x,y) coords need to be saved as (cols, rows)

            newPoint = applyPointTransform(xList, yList, weightingVector, point)

            #print("point: "+str(point)+" --> "+str(newPoint))
           # print(newPoint)
            ##jesus christ, (y,x)  indexes
            # if(newPoint[0]<0):
            #     newPoint[0]=0
            # if(newPoint[1]<0):
            #     newPoint[1] = 0

            ##### These checks might not matter if the canvas is chosen so that its big enough for all possible transformations
            # # if the new x-coord is greater than the no. columns, clamp to max cols
            # if(newPoint[0] > picture.shape[1]):
            #     newPoint[0] = picture.shape[1]
            #
            # # if the new y-coord is greater than the number of rows, clamp to max rows
            # if (newPoint[1] > picture.shape[0]):
            #     newPoint[1] = picture.shape[0]

            ## write out if statements to check morph bounds respect (new, old) image dimensions
            # if x,y <0 - set to 0?
            # if x,y > edges = clamp to edge?

            canvas[newPoint[1]+Y_OFFSET, newPoint[0]+X_OFFSET] = picture[point[1], point[0]]

    return canvas
def applyPointTransform(xList, yList,weightingVector, point):

    numCorrespondencePoints = len(xList)

    rbfList = np.zeros((numCorrespondencePoints))

    xWeights = weightingVector[:numCorrespondencePoints]

    px210 = weightingVector[numCorrespondencePoints:(numCorrespondencePoints+3)]
    yWeights = weightingVector[(numCorrespondencePoints+3):(len(weightingVector)-3)]
    py210 = weightingVector[(len(weightingVector)-3):]

    #compute RBF for target pixel 'point' against each correspondence point
    for i in range(numCorrespondencePoints):
        b = np.array([xList[i], yList[i]])
        rbfList[i] = lgRBF(point,b)

    # perform pixel Transformation ---  BiInterp(translatedX, translatedY)?
    translatedX = round( np.inner(rbfList, xWeights) + px210[0]*point[1] + px210[1]*point[0] + px210[2] ).astype(int)
    translatedY = round( np.inner(rbfList, yWeights) + py210[0]*point[1] + py210[1]*point[0] + py210[2] ).astype(int)

    return [translatedX, translatedY]
def lgRBF(a,b):

    r = np.linalg.norm(a - b)

    # check to make sure we aren't headed towards NaN
    # this is where we inject the RBF formula
    if (r == 0):
        return 0
    else:
        return r ** 2 * np.log(r)

def buildBMatrix(xList, yList, kernelType):

## Variables
    numInputPairs = len(xList)
    onesList = np.ones(numInputPairs)
    Mat = np.zeros(( (numInputPairs+3), (numInputPairs+3) ))

    # print(Mat.shape)
## Statements

    Mat[0,:numInputPairs] = xList     # Write x-List to matrix
    Mat[1,:numInputPairs] = yList     # write y-List to Matrix
    Mat[2,:numInputPairs] = onesList  #write ones line to matrix

    Mat[3:,numInputPairs+1] = np.transpose(xList)      # Write x-List to column
    Mat[3:,numInputPairs]   = np.transpose(yList)      # Write y-List to column
    Mat[3:,numInputPairs+2] = np.transpose(onesList)   # Write ones to column

    ## Fill out the basis-function portion of matrix
    matSubset = Mat[3:,0:numInputPairs]
    Mat[3:, 0:numInputPairs] = basisMatrix(matSubset, xList, yList, kernelType)

    return Mat
def basisMatrix(matSubset, xList, yList, kernelType):    #THIS NEEDS TO BE OPTIMIZED

    if(kernelType=="TPS"):
        matSubset = thinPlateSplineKernel(matSubset, xList, yList)
    elif(kernelType == "GAUS"):
        matSubset = gausKernel(matSubset,xList,yList)
    else:
        print("ERROR: Unrecognized Kernel type!")

    return matSubset
def thinPlateSplineKernel(matrix,xList,yList):

    nx = matrix.shape[0]
    ny = matrix.shape[1]

    # Statements
    for i in range(nx):

        xi = np.array([xList[i], yList[i]])

        for j in range(ny):
            xj = np.array([xList[j], yList[j]])

            matrix[i, j] = lgRBF(xi, xj)

    return matrix
def gausKernel(matrix, xList, yList,):

    ## Variables
    nx = matrix.shape[0]
    ny = matrix.shape[1]

    # Statements
    for i in range(nx):

        xi = np.array([xList[i], yList[i]])

        for j in range(ny):
            xj = np.array([xList[j], yList[j]])

            matrix[i, j] = gaussian_rbf(xi, xj)

    return matrix
def gaussian_rbf(point1, point2):
    sigma = 2
    PI = 3.141

    r = np.linalg.norm(point1 - point2)

    C = 1 / (2 * PI * sigma ** 2)

    soln = C * np.exp( -(r**2 / (2 * sigma ** 2)) )

    return soln
def constructRHSVector(xListInput, yListInput,i,N, deltaX, deltaY):

    ## Variables
    xList = np.asarray(xListInput + (i/N)*deltaX)
    yList = np.asarray(yListInput + (i/N)*deltaY)

    zzz= np.asarray([0,0,0])

    c = np.concatenate((zzz,np.transpose(xList),zzz,np.transpose(yList)))

    return c

# Atlasing
def atlas(parameterFile):

    ## Varialbes
    [xCorrespondencePoints,
    yCorrespondencePoints,
    pictureNames,
    outputFileName,
    kernelType,
    kernelWidth] = readAtlasParamterFile(parameterFile)

    # Determine average correspondence point locations
    xListTarget = np.mean(xCorrespondencePoints, axis=1)
    yListTarget = np.mean(yCorrespondencePoints, axis=1)

    numPictures = len(pictureNames)


    # this needs to be tweaked.
    print("computing ideal bounding box....")
    [NX,NY,X_OFFSET, Y_OFFSET] = generateAtlasCanvas(pictureNames, xCorrespondencePoints, yCorrespondencePoints, xListTarget, yListTarget, kernelType)

    morphImage = np.zeros((NY,NX))

    for i in range(numPictures):

        #read in variables
        filename = pictureNames[i]                      # get picture filename
        sourceTransformImage = np.zeros((NY, NX))       # remember rows = NY  and Cols = NX
        c = atlasRHSVector(xListTarget, yListTarget)  # Construct the righthand side vector
        SourcePic = np.asarray(Image.open(filename))    # load it as 'Source Pic'
        EQSourceimage, equalizedHistogram = histEQ(SourcePic)

        xListInput = xCorrespondencePoints.T[i]         # read-in correspondence points for 'SourcePic'
        yListInput = yCorrespondencePoints.T[i]

        ##Statements
        sourceTransformMatrix = buildBMatrix(xListInput, yListInput, kernelType)
        Dsource = block_diag(sourceTransformMatrix, sourceTransformMatrix)

        # Find weighting coefficients for source and target image deformations:
        sourceDeformCoeffs = np.linalg.solve(Dsource, c)

        print("    Morphing image "+str(filename))
        # Apply these weighting coefficients to source and target pixels to transform the image:
        sourceTransformImage = deformImage(sourceDeformCoeffs, SourcePic, sourceTransformImage,
                                               xListInput, yListInput, X_OFFSET, Y_OFFSET)

        smoothedTransformImage = smooth(sourceTransformImage)   # smooth if possible

        # equalize the histograms for these two images:


        morphImage += smoothedTransformImage
        print("    Saved mapped image "+str(i))


        # change between source transform image and EQSourceImage
        writeArrayToImg(smoothedTransformImage, "/atlasOutput/warpedAtlasImage", i)
        morphImage += smoothedTransformImage

    #average out all values
    morphImage = morphImage/numPictures

    #write to image
    writeArrayToImg(morphImage, "/atlasOutput/"+outputFileName, 1)
    print("     ")
    print("-------------")
    print("Job Complete!  " + str(numPictures) + " pictures averaged to atlasOutput/ folder.")
def atlasRHSVector(xList, yList):

    zzz = np.asarray([0, 0, 0])

    c = np.concatenate((zzz, np.transpose(xList), zzz, np.transpose(yList)))

    return c
def generateAtlasCanvas(pictureNames,xCoords, yCoords, xListTarget, yListTarget, kernelType):
    numPictures = len(pictureNames)

    Xmax = 0
    Xmin = 0
    Ymax = 0
    Ymin = 0

    for i in range(numPictures):

        xListInput = xCoords.T[i]
        yListInput = yCoords.T[i]
        filename = pictureNames[i]

        xCornerMatrix = np.zeros((4, 2))
        yCornerMatrix = np.zeros((4, 2))

        SourcePic = np.asarray(Image.open(filename))
        sourceCorners = getImageCorners(SourcePic)

        # Create 'B' matrix for the sourcePic transform
        sourceTransformMatrix = buildBMatrix(xListInput, yListInput, kernelType)
        Dsource = block_diag(sourceTransformMatrix, sourceTransformMatrix)

        # Construct the righthand side vector
        c = atlasRHSVector(xListTarget, yListTarget)

        # Find weighting coefficients for source and target image deformations:
        sourceDeformCoeffs = np.linalg.solve(Dsource, c)

        for j in range(4):
            sourcePoint = [sourceCorners[j][0], sourceCorners[j][1]]
            newSourcePoint = applyPointTransform(xListInput, yListInput, sourceDeformCoeffs, sourcePoint)

            xCornerMatrix[j,0] = sourceCorners[j][0]
            xCornerMatrix[j,1] = newSourcePoint[0]
            yCornerMatrix[j,0] = sourceCorners[j][1]
            yCornerMatrix[j,1] = newSourcePoint[1]
        #
        # print("xCorner Matrix")
        # print(xCornerMatrix)
        # print("yCorner matrix")
        # print(yCornerMatrix)

        matrixXMax = np.matrix.max(np.asmatrix(xCornerMatrix)).astype("int")
        matrixXMin = np.matrix.min(np.asmatrix(xCornerMatrix)).astype("int")
        Xmax = max(matrixXMax, Xmax).astype("int")
        Xmin = min(matrixXMin, Xmin).astype("int")

        matrixYMax = np.matrix.max(np.asmatrix(yCornerMatrix)).astype("int")
        matrixYMin = np.matrix.min(np.asmatrix(yCornerMatrix)).astype("int")
        Ymax = max(matrixYMax, Ymax).astype("int")
        Ymin = min(matrixYMin, Ymin).astype("int")

    print("------------")
    print("max X: "+str(Xmax))
    print("max Y: "+str(Ymax))

    print("min X: "+str(Xmin))
    print("min Y: "+str(Ymin))

    NX = Xmax + abs(Xmin)+50
    NY = Ymax + abs(Ymin)+50

    print("NX: "+str(NX))
    print("NY: "+str(NY))

    X_OFFSET = abs(Xmin)+20
    Y_OFFSET = abs(Ymin)+20

    return NX, NY, X_OFFSET, Y_OFFSET
def readAtlasParamterFile(parameterFile):

    with open(parameterFile) as f:
        json_data=json.load(f)
    xCoords = np.array(json_data['x-coords'])
    yCoords = np.array(json_data['y-coords'])
    fileNames = np.array(json_data["files"])
    outputFileName = json_data["output"]
    kernelType = json_data["kernel-type"]
    kernelWidth = json_data["kernel-width"]

    return xCoords, yCoords,  fileNames, outputFileName, kernelType, kernelWidth
def readMorphInputs(inputParameters):


    with open(inputParameters) as f:
        json_data=json.load(f)

    xCoords = np.array(json_data['x-coords'])
    xListInput = xCoords.T[0]
    xListTarget = xCoords.T[1]

    yCoords = np.array(json_data['y-coords'])
    yListInput = yCoords.T[0]
    yListTarget = yCoords.T[1]

    fileNames = np.array(json_data["files"])
    sourceFileLocation = fileNames[0]
    targetFileLocation = fileNames[1]

    outputFileName = json_data["output"]

    N  = int(json_data["frames"])

    kernelType = json_data["kernel-type"]
    kernelWidth = json_data["kernel-width"]

    return xListInput, yListInput, xListTarget, yListTarget, sourceFileLocation, targetFileLocation, outputFileName, N, kernelType, kernelWidth

## homework 4 functions
def readPhaseCorreslationInputs(inputfile):

    with open(inputfile) as f:
        json_data=json.load(f)
    directory = json_data["directory"]
    fileNames = np.array(json_data["files"])
    outputFileName = json_data["output"]
    tileFilter = json_data["filter"]

    return directory, fileNames, outputFileName, tileFilter
def phaseCorrelation(inputfile):

    # def phaseCorrelation(im1, im2):
    # Desc:  this function computes the phase correlation between all images speficied within the input (json) file.
    #        and returns the result of the phase correlation in the spatial domain.  We are computing:
    #       p(x,y) = Finv [  ( F*(u,v)G(u,v) ) / ( |F*(u,v)G(u,v)| ) ]
    # and to remove noise:
    #
    #       p(x,y) = Finv [ H(u,v) ( F*(u,v)G(u,v) ) / ( |F*(u,v)G(u,v)| ) ]
    #
    #
    # INPUTS:
    #       inputfile:  A json file specifying the input files and output file name.
    # Outputs:
    #
    #
    # Author:  jimmy Moore
    # Written: 11/8/16
    # Revised: 11/25/16
    #

    ## Variables

    [directory,
     fileNames,
     outputFileName,
     tileFilter] = readPhaseCorreslationInputs(inputfile)

    #construct our global canvas
    canvasHeight = 5000
    canvasWidth  = 5000
    canvas = Image.new("L", (canvasWidth, canvasHeight), "black")

    numFiles = len(fileNames)
    adjacencyMatrix = np.zeros((numFiles, numFiles))
    #open image one
    anchorImage, anchorImageX, anchorImageY = openImageFile(fileNames[0])
    anchorCornerXLocation = [0]*(numFiles)
    anchorCornerYLocation = [0]*(numFiles)

    #declare element = as the (x,y) corner position of picture 1
    anchorCornerXLocation[0] = (int(canvasWidth / 2) - int(anchorImageX / 2))
    anchorCornerYLocation[0] = (int(canvasHeight / 2) - int(anchorImageY / 2))

    #lay down first image
    canvas.paste(Image.fromarray(np.uint8(anchorImage)), ((anchorCornerXLocation[0]), (anchorCornerYLocation[0])))

    picsOverlapped = 0
    timesThroughLoop = 1
    cwd = os.getcwd()


    ## Statements
    printFileNames(fileNames)

    if(tileFilter == 'bw'):
        print("using butterworth Filter for this dataset.")
    elif tileFilter == 'g':
        print("Using Gaussian filter for this dataset")
    else:
        print("did not recognize filter format, defaulting to gaussian")


    print("Computing Adjacency matrix of all included files...")
    print()
    adjacencyMatrix = computeAdjacency(adjacencyMatrix, fileNames, tileFilter)
    print(adjacencyMatrix)

    print()
    print("Picture intersections:")
    firstImageHit = first_true4(adjacencyMatrix)
    print(firstImageHit)

    #for every picture in our directory
    for i in range(numFiles):
        imgA, imgAx, imgAy = openImageFile(fileNames[i])

        #perform direct comparison with every picture afterwards
        for j in range(i+1,numFiles):
            print()
            print("Comparison "+str(timesThroughLoop)+": Image "+str(i)+" vs. Image "+str(j))
            print()

            imgB, imgBx, imgBy = openImageFile(fileNames[j])

            maxX, maxY = setCorrelationCanvasSize(imgA, imgB)
            offset, phasePlot = computePhaseCorrelation(imgA, imgB, maxX, maxY, tileFilter)

            # if we fine and overlap between the images...
            if(offset):
                earliestHit = firstImageHit[j]
                picsOverlapped = picsOverlapped + 1

                imgCorner = exploreOverlap(imgA, imgB, offset)
                [shiftX, shiftY] = determineImageShift(imgCorner, offset, imgA, imgB)

                if (i == 0):
                    # If this is our first time through the inner loop, save all corner info
                    anchorCornerXLocation[j] = anchorCornerXLocation[earliestHit] + shiftX
                    anchorCornerYLocation[j] = anchorCornerYLocation[earliestHit] + shiftY

                print("Images match!")

                print("  First image to hit: " + str(earliestHit))
                print("  Parent image corner position: (" + str(anchorCornerXLocation[earliestHit]) + "," + str(
                    anchorCornerYLocation[earliestHit]) + ")")
                print("  Image offsets: ("+str(shiftX)+","+str(shiftY)+")")
                print("  Moving image to (" + str(anchorCornerXLocation[earliestHit] + shiftX) + "," + str(
                    anchorCornerYLocation[earliestHit] + shiftY) + ")")
                plotCorrelations(imgA, imgB, phasePlot)

                #deal with pair-wise comparison
                #construct our canvas
                # mosaicHeight = (int(imgAy/2) + 2*imgBy)
                # mosaicWidth  = (int(imgAx/2) + 2*imgBx)
                # mosaic = Image.new("L", (mosaicWidth, mosaicHeight), "black")
                # mosaic.paste(Image.fromarray(np.uint8(imgA)), ( ( int(mosaicWidth/2) - int(imgAx/2)), (int(mosaicHeight/2) - int(imgBy/2))))
                # mosaic.paste(Image.fromarray(np.uint8(imgB)), ( ( int(mosaicWidth/2) - int(imgAx/2) + shiftX), ( int(mosaicHeight/2) - int(imgBy/2) + shiftY)))
                # #save pair-wise composite
                # mosaic.save(cwd+"/"+str(directory)+"/pairwiseComparisons/mosaicOutput"+str(picsOverlapped)+"c"+str(imgCorner)+".png")

                #write position to global canvas
                canvas.paste(Image.fromarray(np.uint8(imgB)), ((anchorCornerXLocation[i] + shiftX), (anchorCornerYLocation[i] + shiftY)))
                canvas.save(cwd + "/" + str(directory) + "/" + str(outputFileName) + "pass"+str(picsOverlapped)+".png")
            else:
                print()
                print("   Insufficient image overlap.  Passing...")
                print()
            print("============================")
            print("============================")
            print()

            timesThroughLoop += 1
        print("anchorCornerXLocations")
        print(anchorCornerXLocation)

    print("writing mosaic out to disk:")
    canvas.save(cwd + "/" + str(directory) + "/"+str(outputFileName)+".png")
    print("...Done.")
def computeAdjacency(aM, fileNames, tileFilter):
    ##Variables
    numFiles = len(fileNames)

    ## Statements
    for i in range(numFiles): # for every picture in our directory
        imgA = openImageFile(fileNames[i])[0]
        for j in range(i + 1, numFiles): # perform direct comparison with every picture afterwards
            imgB = openImageFile(fileNames[j])[0]
            maxX, maxY = setCorrelationCanvasSize(imgA, imgB)
            offset = computePhaseCorrelation(imgA, imgB, maxX, maxY, tileFilter)[0]
            if (offset):
                aM[i, j] = 1 # mark if there is some computed connection
    aM += np.transpose(aM)
    return aM
def first_true4(a):
# from: http://stackoverflow.com/questions/11731428/finding-first-non-zero-value-along-axis-of-a-sorted-two-dimensional-numpy-array
    di = {}
    for i, ele in enumerate(np.argmax(a, axis=1)):
        if ele == 0 and a[i][0] == 0:
            di[i] = None
        else:
            di[i] = ele

    return di
def exploreOverlap(im1, im2, offset):

    im1 = np.asarray(im1)
    im2 = np.asarray(im2)
    im1y, im1x = im1.shape
    im2y, im2x = im2.shape

    ##Variables
    oY = im2y - offset[0]
    oX = im2x - offset[1]
    correlationList = [0,0,0,0]

    ## Statements
    print()
    print("========= Overlap Views ============")

    print()
    upperLeft1 = im1[0:(im2y - oY), 0:(im2x - oX)]
    upperLeft2 = im2[(oY):im2y, (oX):im2x]
    correlationList[0] = corr2(upperLeft1, upperLeft2)
    print("upper left (corner 0), corr = "+str(correlationList[0]))
    #plotSubsets(upperLeft1, upperLeft2)

    print()
    upperRight1 = im1[0:(im2y - oY), (im1x - oX):im1x]
    upperRight2 = im2[oY:im2y, 0:oX]
    correlationList[1] = corr2(upperRight1, upperRight2)
    print("upper right (corner 1), corr = "+str(correlationList[1]))
    #plotSubsets(upperRight1, upperRight2)

    print()
    lowerRight1 = im1[(im1y - oY):im1y, (im1x - oX):im1x]
    lowerRight2 = im2[0:oY, 0:oX]
    correlationList[2] = corr2(lowerRight1, lowerRight2)
    print("Lower Right (corner 2), corr = "+str(correlationList[2]))
    #plotSubsets(lowerRight1, lowerRight2)

    print()
    lowerLeft1 = im1[(im1y-oY):im1y, 0:(im2x-oX)]
    lowerLeft2 = im2[0:oY,oX:im2x]
    correlationList[3] = corr2(lowerLeft1, lowerLeft2)
    print("lower left (corner 3), corr = "+str(correlationList[3]))
    #plotSubsets(lowerLeft1, lowerLeft2)

    # print("0) upper left size:")
    # print("   1: " + str(upperLeft1.shape))
    # print("   2: " + str(upperLeft2.shape))
    # print("   corr: " + str(correlationList[0]))
    # print()
    #
    # print("1) upper right size:")
    # print("   1: " + str(upperRight1.shape))
    # print("   2: " + str(upperRight2.shape))
    # print("   corr: " + str(correlationList[1]))
    # print()
    # print("2) lower right size:")
    # print("   1: " + str(lowerRight1.shape))
    # print("   2: " + str(lowerRight2.shape))
    # print("   corr: " + str(correlationList[2]))
    # print()
    #
    # print("3) lower left size:")
    # print("   1: "+str(lowerLeft1.shape))
    # print("   2: " + str(lowerLeft2.shape))
    # print("   corr: "+str(correlationList[3]))
    # print()

    correlationCorner = maxl(correlationList)
    print()
    print("   Max Correlation: "+str(max(correlationList)))
    print("   Max Correlation Corner: "+str(correlationCorner))

    return correlationCorner
def maxl(l): return l.index(reduce(lambda x,y: max(x,y), l))
def openImageFile(filename):
    IMG = Image.open(filename)
    IMG = np.asarray(IMG)
    IMG = histEQ(IMG)[0]
    IMGy, IMGx = IMG.shape
    return IMG, IMGx, IMGy
def setCorrelationCanvasSize(im1, im2):

    im1 = np.asarray(im1)
    im2 = np.asarray(im2)

    # print("imgA size: " + str(im1.shape))
    # print("imgB size: " + str(im2.shape))
    im1y, im1x = im1.shape
    im2y, im2x = im2.shape

    maxX = np.max((im1x, im2x)) * 1
    maxX = roundto2Power(int(maxX))

    maxY = np.max((im1y, im2y)) * 1
    maxY = roundto2Power(int(maxY))
    #
    # print("maxx: "+str(maxX))
    # print("maxY: "+str(maxY))

    return maxX, maxY
def compositeImages(im1, im2, oX, oY):

    # we assume we are pasting image 2 onto image 1
    im1Y, im1X = im1.size
    im2Y, im2X = im2.size

    if( (oX+im2X)<im1X and (oY+im2Y)<im1Y ):
        # the picture will fit within im1 canvas -- just paste directly
        print("these pictures nest...")
        im1.paste(im2, (oX, oY))
        return im1

    else:
        ## Image 2 is not within the bounds of image 1.

        #Make canvas bigger
        canvas = Image.new('L', (im1X+oX, im1Y+oY), "black" )
        canvas.paste(im1, (oX, oY))
        addedY = im2Y - (im1Y - oY)  #compute extra Y pixels needed
        addedX = im2X - (im1X - oX)  #compute extra X pixels needed
        canvas.paste(im2, (addedX, addedY))
        return canvas

    ##Important -- output image of the composite.
def determineImageShift(corner,offset, im1, im2):

    ## Variables
    im1 = np.asarray(im1)
    im2 = np.asarray(im2)
    im1y, im1x = im1.shape
    im2y, im2x = im2.shape

    oX = im2x - offset[1]
    oY = im2y - offset[0]


    if(corner==0):
        offsetX = -oX
        offsetY = -oY
    elif(corner==1):
        offsetX = im1x - oX
        offsetY = -oY

    elif(corner==2):  # works
        offsetX = (im1x - oX)
        offsetY = (im2y - oY)

    elif(corner==3):  #works

        offsetX = (oX)
        offsetY = (oY)

    return offsetX, offsetY

    print("Move img 2 in these directions to overlap Img 1: ")
    print("  in X --> "+str(offsetX))
    print("  in Y --> "+str(offsetY))
    print()

    return offsetX, offsetY
def mean2(x):
    y = np.sum(x) / np.size(x);
    return y
def corr2(a, b):
    a = a - mean2(a)
    b = b - mean2(b)

    r = (a * b).sum() / math.sqrt((a * a).sum() * (b * b).sum());
    return r
def roundto2Power(dim):
    # from http://stackoverflow.com/questions/14267555/how-can-i-find-the-smallest-power-of-2-greater-than-n-in-python/14267825#14267825
    return 1<<(dim-1).bit_length()
def printFileNames(fileNames):

    numFiles = len(fileNames)

    print("===== Phase Correlation Showcase! =====")
    print("     Number of pictures: "+str(numFiles))

    for i in range(numFiles):
        print(" "+str(fileNames[i]))

    print("========================================")
    print()
def computePhaseCorrelation(im1, im2,xdim, ydim,tileFilter):
#def computePhaseCorrelation(im1, im2,xdim, ydim, tileFilter):
# Inputs:
#       im1:    the first image
#       im2:    the second image
#       xdim:   largest x-canvas size of the two images (rounded to next biggest power of 2)
#       ydim:   largest y-canvas size of the two images (rounded to next biggest power of 2)
# output:
#       maxOffset: The pixel position of the highest phase correlation response (given as [y,x]

    ##Variables
    im1 = np.asarray(im1)
    im2 = np.asarray(im2)

    F = np.fft.fft2(im1, s=(xdim, ydim))
    G = np.fft.fft2(im2, s=(xdim, ydim))

    if tileFilter == 'bw':

        H = butterworthFilter(xdim, ydim)
    elif tileFilter == 'g':
        H = gaussianFilter(xdim, ydim)
    else:
        H = gaussianFilter(xdim, ydim)

    Fstar = np.conj(F)
    Gstar = np.conj(G)
    MAX_PEAK = 0.011

    numerator = H*F*Gstar
    denominator = np.absolute(numerator)
    expression = numerator/denominator

    p = np.fft.ifft2(expression)
    p = np.abs(p)

    print("peak phase correlation return: " + str(np.amax(p)))
    if(np.amax(p) > MAX_PEAK):

        maxOffset = np.unravel_index(p.argmax(), p.shape)
        return maxOffset, p

    else:
        return 0, 0
def plotCorrelations(im1, im2, p):

    fig = plt.figure(figsize=(20, 10))

    ax1 = fig.add_subplot(131)
    ax1.imshow(im1, cmap="Greys_r")

    ax2 = fig.add_subplot(132)
    ax2.imshow(im2, cmap="Greys_r")

    ax3 = fig.add_subplot(133)
    ax3.imshow(p, cmap="Greys_r")

    plt.tight_layout()

    plt.show()
def plotSubsets(im1,im2):
    fig = plt.figure(figsize=(20, 10))

    ax1 = fig.add_subplot(121)
    ax1.imshow(im1, cmap="Greys_r")

    ax2 = fig.add_subplot(122)
    ax2.imshow(im2, cmap="Greys_r")

    plt.tight_layout()
    plt.show()
def butterworthFilter(xdim, ydim):
    # def butterworthFilter():
    # Desc:
    #Inputs:
    #
    # Outputs:
    #
    # author: Jimmy Moore
    # Written: 11/8/16
    # revised: 11/10/16

    ## Variables
    Fc = 200
    p = 2

    ## Statements

    x = np.arange(-int(xdim / 2), int(xdim / 2))
    y = np.arange(-int(ydim / 2), int(ydim / 2))
    xx, yy = np.meshgrid(x, y)

    h = 1 / ( 1 + (np.sqrt(xx * xx + yy * yy) / Fc) ** (2 * p) )
    H = np.fft.fft2(h, s=(xdim, ydim))

    return H
def gaussianFilter(xdim,ydim):
    # def gaussianFilter():
    # Desc:
    #Inputs:
    #
    # Outputs:
    #
    # author: Jimmy Moore
    # Written: 11/8/16
    # revised: 11/10/16

    ## Variables
    sigma = 7
    PI = 3.141


    ## Statements

    x = np.arange(-int(xdim / 2), int(xdim / 2))
    y = np.arange(-int(ydim / 2), int(ydim / 2))
    xx, yy = np.meshgrid(x, y)

    h = 1 /(2*PI*sigma**2) * np.exp( -1/(2*sigma**2) * ((xx*xx + yy*yy)/(2*sigma**2)))
    H = np.fft.fft2(h, s=(xdim, ydim))

    return H

## Homework 5 Functions

