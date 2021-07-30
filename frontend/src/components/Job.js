import classes from './Job.module.css';
import {useState} from 'react';
import Backdrop from './Backdrop';
import Notes from './Notes';
import Timesheet from './Timesheet';
import Edit from './Edit';

function Job(props)
{
    const [errorMsg, setMsg] = useState("");
    const [backdropIsVisible, setBackdropVisiblity] = useState(false);
    const [notesAreVisible, setNoteVisibility] = useState(false);
    const [timesheetIsVisible, setTimesheetVisibility] = useState(false);
    const [editIsVisible, setEditVisibility] = useState(false);
    const [notes, setNotes] = useState([]);
    const [times, setTimes] = useState([]);

    function renderNotes()
    {
        setNoteVisibility(true);
        setBackdropVisiblity(true);
    }

    function loadTimesheet()
    {
        setTimesheetVisibility(true);
        setBackdropVisiblity(true);
    }

    function loadEdit()
    {
        setEditVisibility(true);
        setBackdropVisiblity(true);
    }

    function closeAll()
    {
        setBackdropVisiblity(false);
        setNoteVisibility(false);
        setTimesheetVisibility(false);
        setEditVisibility(false);
    }

    function reformatDate(input)
    {
        const year = input.substring(0, 4);
        const month = input.substring(5, 7);
        const day = input.substring(8, 10);
        return (month + '/' + day + '/' + year);
    }

    async function loadNotes()
    {
        var fooid = props.id;

        const Data =
        {
            "fooid": fooid
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchNotes', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            
            if(res.error == 'Success')
            {
                setNotes(res.notes);
            }else{
                setNotes([]);
            }

        }catch(e){
            alert(e.toString());
        }

        renderNotes();
    }

    async function loadTimes()
    {
        var fooid = props.id;

        const Data =
        {
            "fooid": fooid
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/searchTimesheet', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            
            if(res.error == 'Success')
            {
                setTimes(res.times);
            }else{
                setTimes([]);
            }

        }catch(e){
            alert(e.toString());
        }

        loadTimesheet();
    }

    async function markComplete()
    {
        var fooid = props.id;

        const Data =
        {
            "fooid": fooid
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/markorder', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }
    }

    async function deleteJob()
    {
        var id = props.id;

        const Data =
        {
            "id": id
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/deleteorder', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }
    }

    async function clockEvent()
    {
        var dateobj = new Date();
        var timestr = dateobj.toLocaleTimeString([], {hour: 'numeric' ,minute: '2-digit'});
        var user = JSON.parse(localStorage.getItem('user_data'));
        var datestr = dateobj.toISOString();

        var date = datestr.substring(0, 10);
        
        const Data =
        {
            email: user.Email,
            fooid: props.id,
            time: timestr,
            date: date,
            title: props.title,
            fn: user.FirstName,
            ln: user.LastName
        };

        var signedup = false;
        for(let i = 0; i < props.workers.length; i++)
        {
            if(props.workers[i].email == user.Email)
                signedup = true;
        }

        if(!signedup){
            setMsg("Must be signed up to clock in");

        }else{
            var js = JSON.stringify(Data);
            try{
                const response = await fetch('https://cop4331group2.herokuapp.com/api/clockEvent', 
                {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
                var res = JSON.parse(await response.text());
                setMsg(res.error);
    
            }catch(e){
                alert(e.toString());
            }
        }

        
    }

    async function signEvent()
    {
        var user = JSON.parse(localStorage.getItem('user_data'));

        var email = user.Email;
        var fn = user.FirstName;
        var ln = user.LastName;
        var phone = user.Phone;
        var current = props.workers.length;
        var max = props.maxWorkers;

        const Data =
        {
            email: email,
            id: props.id,
            firstName: fn,
            lastName: ln,
            phone: phone,
            current: current,
            max: max
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/signJob', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }
    }

    return (
        <div>
            <div className={classes.jobcard}>
                <div className={classes.cardheading}>
                    <h3 className={classes.h3}>{props.title}</h3>
                </div>
                <div>
                    <div className={classes.spacer}>
                        <span className={classes.span}>Location: </span>
                        <span className={classes.address}>{props.address}</span>
                    </div>
                    <div>
                        <span className={classes.spanD}>Duration: </span>
                        <span className={classes.date}>{reformatDate(props.start)}</span>
                        <span className={classes.span2}> to </span>
                        <span className={classes.date2}>{reformatDate(props.end)}</span>
                    </div>
                    <div>
                        <span className={classes.spanC}>Client: </span>
                        <span className={classes.client}>{props.client}</span>
                        <span className={classes.email}>{props.email}</span>
                        <span className={classes.phone}>{props.phone}</span>
                    </div>
                    <div className={classes.center}>
                        <span className={classes.details}>Team: {props.workers.length}/{props.maxWorkers}</span><br></br>
                        <ul className={classes.ul}>
                            {props.workers.map(worker => 
                                <li className={classes.worker} key={worker.email}>
                                    <span className={classes.info}>{worker.firstName} {worker.lastName}</span>
                                    <span className={classes.info}>{worker.email}</span>
                                    <span className={classes.info}>{worker.phone}</span>
                                </li>
                            )}
                        </ul>
                    </div>
                    <div className={classes.center}>
                        <span className={classes.details}>Details:</span><br></br>
                        <p className={classes.brief}>{props.briefing}</p>
                    </div>
                    <div>
                        {errorMsg && <p className={classes.error}>{errorMsg}</p>}
                    </div>
                </div>
                <div className={classes.cardfooter}>
                    <button className={classes.noteButton} onClick={loadNotes}>Notes</button>
                    <button className={classes.noteButton} onClick={loadTimes}>Timesheet</button>
                    {(props.utype == 0 && !props.completed) && <button className={classes.signButton} onClick={signEvent}>Sign on/off</button>}
                    {(props.utype == 0 && !props.completed) && <button className={classes.signButton} onClick={clockEvent}>Clock in/out</button>}
                    {(props.utype == 1 && !props.completed) && <button className={classes.sign2Button} onClick={deleteJob}>Delete</button>}
                    {(props.utype == 1 && !props.completed) && <button className={classes.sign2Button} onClick={loadEdit}>Edit</button>}
                    {(props.utype == 1 && !props.completed) && <button className={classes.sign2Button} onClick={markComplete}>Mark Done</button>}
                </div>
            </div>
            {backdropIsVisible && <Backdrop onClick={closeAll}></Backdrop>}
            {notesAreVisible && <Notes notes={notes} completed={props.completed} jid={props.id} title={props.title} onClick={closeAll}></Notes>}
            {timesheetIsVisible && <Timesheet input={times} onClick={closeAll}></Timesheet>}
            {editIsVisible && <Edit 
                title = {props.title}
                address = {props.address}
                client = {props.client}
                email = {props.email}
                phone = {props.phone}
                maxWorkers = {props.maxWorkers}
                start = {props.start}
                end = {props.end}
                briefing = {props.briefing}
                jid = {props.id}
                current = {props.workers.length}
                onClick={closeAll}></Edit>}
        </div>
    );
}

export default Job;