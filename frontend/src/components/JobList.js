import classes from './JobList.module.css';
import Job from './Job';
function JobList(props)
{
    var arr = props.jobs;
    var filtered = arr.filter(function (el) {
        return el != null;
    });
    
    return(
        <div>
            <ul className={classes.ul}>
                {filtered.map(job =>
                <Job
                    key={job._id}
                    title={job.title}
                    address={job.address}
                    start={job.start}
                    end={job.end}
                    client={job.clientname}
                    email={job.email}
                    phone={job.clientcontact}
                    maxWorkers={job.maxworkers}
                    workers={job.workers}
                    briefing={job.briefing}
                    utype = {props.utype}
                    completed = {job.completed}
                ></Job>)}
            </ul>
        </div>
    );
}

export default JobList;