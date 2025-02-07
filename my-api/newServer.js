const express = require("express");
const multer = require("multer");
const mongoose = require("mongoose");

const app = express();

// Connect to MongoDB
async function connectDB() {
    try {
        await mongoose.connect("mongodb+srv://Admin:Vaidant08@yumfac.2cjxx.mongodb.net/");
        console.log("Connected to MongoDB");
    } catch (error) {
        console.error("Error connecting to MongoDB:", error);
    }
}

// Call the function to connect to the database
connectDB();

// Set up storage for uploaded files
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/"); // Folder where images will be stored
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + "-" + file.originalname); // Unique file name
    }
});

const upload = multer({
    storage: storage,
    limits: { fileSize: 50 * 1024 * 1024 }  // 50MB file size limit
});

app.use(express.json({ limit: '50mb' }));  // Set limit to 50MB
app.use(express.urlencoded({ extended: true, limit: '50mb' }));  // Set limit to 50MB

// Product Schema
const productSchema = new mongoose.Schema({
    pname: { type: String, required: true },
    ppreference: { type: String, required: true },
    pdescription: { type: String, required: true },
    pservingInfo: String,
    pnote: String,
    pimage: String,
});

const Product = mongoose.model('Product', productSchema);

// Packaging and Delivery Schema
const packagingAndDeliverySchema = new mongoose.Schema({
    pTime: { type: Number, required: true },
    pTimeUnit: { type: String, required: true },
    pRadius: { type: Number, required: true },
    pRadiusUnit: { type: String, required: true },
    pFreeDelivery: { type: Boolean, required: true },
    pFreeDeliveryUnit: { type: String, required: true },
    pOV1: Number,
    pPrice1: Number,
    pOV2: Number,
    pPrice3: Number,
});

const PackagingAndDelivery = mongoose.model('PackagingAndDelivery', packagingAndDeliverySchema);

// Shop Data Schema
const shopDataSchema = new mongoose.Schema({
    shopName: { type: String, required: true },
    fssaiId: { type: String, required: true }
});

const ShopData = mongoose.model('ShopData', shopDataSchema);

// Stock Status Schema
const stockStatusSchema = new mongoose.Schema({
    status: { type: Boolean, required: true },
    name: { type: String, required: true },
    date: { type: String, required: true }
});

const StockStatus = mongoose.model('StockStatus', stockStatusSchema);

// Endpoint to add a product
app.post("/api/add_product", upload.single("pimage"), async (req, res) => {
    console.log("Request Body:", req.body);

    if (!req.body.pname || !req.body.ppreference || !req.body.pdescription) {
        return res.status(400).send({
            status_code: 400,
            message: "Missing required product fields",
        });
    }

    const newProduct = new Product({
        pname: req.body.pname,
        ppreference: req.body.ppreference,
        pdescription: req.body.pdescription,
        pservingInfo: req.body.pservingInfo,
        pnote: req.body.pnote,
        pimage: req.file ? req.file.path : null,
    });

    try {
        await newProduct.save();
        console.log("Product Added:", newProduct);

        res.status(200).send({
            status_code: 200,
            message: "Product added successfully",
            product: newProduct,
        });
    } catch (error) {
        console.error("Error adding product:", error);
        res.status(500).send({
            status_code: 500,
            message: "Failed to add product",
        });
    }
});

// Endpoint for packaging and delivery details
app.post("/api/packagingAndDelivery", async (req, res) => {
    console.log("Request Body:", req.body);

    if (!req.body.pTime || !req.body.pRadius) {
        return res.status(400).send({
            status_code: 400,
            message: "Missing required packaging and delivery fields",
        });
    }

    const newPackagingAndDelivery = new PackagingAndDelivery({
        pTime: req.body.pTime,
        pTimeUnit: req.body.pTimeUnit,
        pRadius: req.body.pRadius,
        pRadiusUnit: req.body.pRadiusUnit,
        pFreeDelivery: req.body.pFreeDelivery,
        pFreeDeliveryUnit: req.body.pFreeDeliveryUnit,
        pOV1: req.body.pOV1,
        pPrice1: req.body.pPrice1,
        pOV2: req.body.pOV2,
        pPrice3: req.body.pPrice3,
    });

    try {
        await newPackagingAndDelivery.save();
        console.log("Packaging and Delivery Added:", newPackagingAndDelivery);

        res.status(200).send({
            status_code: 200,
            message: "Packaging and Delivery data added successfully",
            data: newPackagingAndDelivery,
        });
    } catch (error) {
        console.error("Error adding packaging and delivery:", error);
        res.status(500).send({
            status_code: 500,
            message: "Failed to add packaging and delivery data",
        });
    }
});

// Endpoint to fetch shop data
app.get("/api/shopData", async (req, res) => {
    try {
        const shopData = await ShopData.find();
        if (shopData.length > 0) {
            res.status(200).send({
                status_code: 200,
                products: shopData,
            });
        } else {
            res.status(404).send({
                status_code: 404,
                message: "No shop data found",
            });
        }
    } catch (error) {
        console.error("Error fetching shop data:", error);
        res.status(500).send({
            status_code: 500,
            message: "Failed to fetch shop data",
        });
    }
});

// Endpoint for stock status
app.get("/api/stockStatus", async (req, res) => {
    try {
        const stockStatus = await StockStatus.find();
        if (stockStatus.length > 0) {
            res.status(200).send({
                status_code: 200,
                products: stockStatus,
            });
        } else {
            res.status(404).send({
                status_code: 404,
                message: "No stock status data found",
            });
        }
    } catch (error) {
        console.error("Error fetching stock status:", error);
        res.status(500).send({
            status_code: 500,
            message: "Failed to fetch stock status",
        });
    }
});

// Start the server
app.listen(5000, () => {
    console.log("Connected to server at 5000");
});
