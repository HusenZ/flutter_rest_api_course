import { asyncHandler } from "../utils/asyncHandler.js";
import { ApiError } from "../utils/ApiError.js";
import { User } from "../models/user.model.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import jwt from "jsonwebtoken";

const generateAccessAndRefreshTokens = async(userId)=>{
    try {
        const user = await User.findById(userId)
        const accessToken = user.generateAccessToken()
        const refreshToken = user.generateRefreshToken()

        user.refreshToken = refreshToken
        await user.save({ validateBeforeSave: false })

        return {accessToken, refreshToken}
    } catch (error) {
        throw new ApiError(500, `Something went wrong while generting Access and Refresh Token ${error}`)
    }
}

const registerUser = asyncHandler(async (req, res)=>{
    // get user details from frontend
    // validation - not empty
    // check if user already exists: username, email
    // check for images, check for avatar
    // upload them to cloudinary, avatar
    // create user object - create entry in db
    // remove password and refresh token field from response
    // check for user creation
    // return respose

    const {fullname, email, username, password} = req.body
    console.log("password: ", password);

    /* check each one by one for beginner level
    if(fullname === ""){
        throw new ApiError(400, "Full name is required");
    }
    */
   if(
     [fullname, email, username, password].some((field)=> field?.trim() === "")
   ){
        throw new ApiError(400, "All fields are required");
   }

   const existedUser = await User.findOne({
    $or: [{ username }, { email }]
   })

   if(existedUser){
    throw new ApiError(409, "User with email or username already exists");
   }



   const user = await User.create({
    fullname,
    email,
    password,
    username: username.toLowerCase()
   })

   const creaatedUser = await User.findById(user._id).select(
    "-password -refreshToken"
   )

   if(!creaatedUser){
    throw new ApiError(500, "Something wend wrong while registering the user");
   }

   return res.status(201).json(
    new ApiResponse(200, creaatedUser, "User registerd Successfully" )
   )

}) 

const loginUser = asyncHandler(async(req, res)=>{
    // req body -> data
    // username or email
    // find the user
    // password check
    // access and refresh token
    // send cookie

    const {email, username, password} = req.body
    
    if(!username && !email){
        throw new ApiError(400, "username or email is required")
    }

    // Here is the alternative of above code 
    // if(!(username || email)){
    //     throw new ApiError(400, "username or email is required")
    // }

    const user = await User.findOne({ 
        $or: [{ username }, { email },]
    })

    if(!user){
        throw new ApiError(400, "User Not Found")
    }

    const isPasswordValid = await user.isPasswordCorrect(password)

    if(!isPasswordValid){
        throw new ApiError(401, "Invalid User Credentials")
    }

    const {accessToken, refreshToken} = await generateAccessAndRefreshTokens(user._id) // tokens were created here so old user is not having it
    // you can make call to db or update the user depends on the way you want to handle it

    const loggedinUser = await User.findById(user._id).select("-password -refreshToken")

    //Sending cookie
    const options = {
        httpOnly: true,
        secure: true,
    }

    return res
    .status(200)
    .cookie("accessToken",accessToken, options)
    .cookie("refreshToken", refreshToken, options)
    .json(
        new ApiResponse(
            200,
            {
                user: loggedinUser, accessToken, refreshToken,
            },
            "User Logged in successfully"
        )
    )
    
})

const logoutUser = asyncHandler(async(req, res)=>{
    // remove cookie
    // refresh token reset
   await User.findByIdAndUpdate(
        req.user._id,
        {
            $set: {
                refreshToken: undefined
            }
        },
        {
            new: true,
        }
   )

   const options = {
        httpOnly: true,
        secure: true,
   }   

   return res
   .status(200)
   .clearCookie("accessToken", options)
   .clearCookie("refreshToken", options)
   .json(new ApiResponse(200, {}, "User logged out successfully"))

})

const refreshAccessToken = asyncHandler(async(req, res)=>{
    const incomingRefreshToken = req.cookies.refreshToken || req.body.refreshToken

    if(!incomingRefreshToken){
        throw new ApiError(401, "--->Unauthorized Request")
    }

    try {
        const decodedToken = jwt.verify(incomingRefreshToken, process.env.process.env.REFRESH_TOKEN_SECRET)
    
        const user = await User.findById(decodedToken?._id)
        
        if(!user){
            throw new ApiError(401, "invalid refresh token")
        }
    
        if(incomingRefreshToken !== user?.refreshToken){
            throw new ApiError(401, "Refresh token is expired or used")
        }
    
        const options = {
            httpOnly: true,
            secure: true,
        }
    
        const {accessToken, newRefreshToken} = await generateAccessAndRefreshTokens(user._id)
    
        return res
        .status(200)
        .cookie("accessToken", accessToken, options)
        .cookie("refreshToken", newRefreshToken, options)
        .json(
            new ApiResponse(
                200,
                {accessToken, refreshToken: newRefreshToken},
                "Access Token Refreshed"
            )
        )
    } catch (error) {
        throw new ApiError(401, error?.message || "Invalid refresh token")
    }
})

export {
    registerUser,
    loginUser,
    logoutUser,
    refreshAccessToken,
}