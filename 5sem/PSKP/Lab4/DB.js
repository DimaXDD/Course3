const EventEmitter = require("events");

class DB extends EventEmitter {
    
    constructor(){
        super();
        this.db_data = 
        [
            {
                ID:"1",
                FIO: "Trubach D.S.", 
                BDay: "2004-01-10"
            },
            {
                ID:"2",
                FIO: "Artsykhovich P.A.", 
                BDay: "2004-01-28"
            },
            {
                ID:"3",
                FIO: "Korenchuk A.V.", 
                BDay: "2003-10-15"
            },
            {
                ID:"4",
                FIO: "Gaykov D.V.", 
                BDay: "2004-01-30"
            },
                        
        ]
    }

    async select(obj) {
        let elem;
        if (obj != undefined && "ID" in obj) {
            elem = this.db_data.find(item => item.ID === obj.ID);
        }

        if (elem != undefined) {
            let index = this.db_data.indexOf(elem);
            return this.db_data[index];
        }
        else {
            if (obj != undefined && "BDay" in obj && obj.BDay == -1)
                return null;
            else
                return this.db_data;
        }
    }
    async insert(obj) {
        if (obj.BDay != undefined && new Date(obj.BDay) > new Date()) {
            console.log("Error: BDay is greater than today's date.")
        }
        else {
            let elem = this.db_data.find(item => item.ID === obj.ID)
            
            console.log(elem);
            if(elem != undefined){
                console.log("ID used");
            }
            else
                this.db_data.push({ID : obj.ID, FIO : obj.FIO, BDay: obj.BDay});
        }
    }

    async update(obj) {
        if(obj.BDay != undefined && new Date(obj.BDay) > new Date()) {
            console.log("Error: BDay is greater than today's date.")
        }
        else{
            let elem = this.db_data.find(item => item.ID === obj.ID)
            
            if(elem != null) {
                let index = this.db_data.indexOf(elem);
                if(index !== -1)
                    this.db_data[index] = obj;
            }
            console.log(this.db_data);
        }
    }
    async delete(obj) {
        let elem = this.db_data.find(item => item.ID === obj.ID);

        if(elem != null) {
            let index = this.db_data.indexOf(elem);
            if(index !== -1)
                this.db_data.splice(index, 1);
        }
        console.log(this.db_data);
    }
}

exports.DB = DB;