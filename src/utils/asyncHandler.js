// This is promise method
/// a higher order function
const asyncHandler = (reqestHandler)=>{
    return (req, res, next)=>{
        Promise.resolve(reqestHandler(req,res,next)).catch((error)=>next(error))
    }
}

export {asyncHandler}

// This is try catch method
// const asyncHandler = (fn)=>async(req, res, next)=>{
//     try {
//         await fn(req, res, next)
//     } catch (error) {
//         res.status(error.code || 500).json({
//             success: false,
//             message: error.message,
//         })
//     }

// } //  (a function as parm) => {()=>{} call that here}