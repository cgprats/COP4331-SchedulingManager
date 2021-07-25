import classes from './JobList.module.css';
import Job from './Job';
function JobList(props)
{
    return(
        <div>
            <ul className={classes.ul}>
                {props.jobs.map(job =>
                <Job
                    key={job.id}
                    title={job.title}
                    address={job.address}
                    start={job.start}
                    end={job.end}
                    client={job.client}
                    email={job.email}
                    phone={job.phone}
                    maxWorkers={job.maxWorkers}
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